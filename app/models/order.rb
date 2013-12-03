# encoding: utf-8
# vim:ts=2:sw=2
class Order < ActiveRecord::Base
	attr_reader :release_id
	has_many :line_items
	belongs_to :release

	STATE_CANCELED  = 'キャンセル'
	STATE_DELIVERED = '引渡し済み'
	STATE_NORMAL    = ''

	def self.active_orders_of_the_day(release_id, year, month, day)
		where({state: STATE_NORMAL,
		release_id: release_id, due_year: year, due_month: month, due_day: day
		}).order('due ASC')
	end

	def self.all_active_orders
		where({state: STATE_NORMAL})
	end

	def self.recent
		# "今日の予約" か "最近更新した予約" を取得する．
		t = Time.current
		caption = '今日の予約'
		orders = where({
		state: STATE_NORMAL, due_year: t.year, due_month: t.month, due_day: t.day
		}).order('due ASC').limit(16)
		if orders.size <= 0
			caption = '最近更新した予約'
			orders = find(:all, order: 'ordered_at DESC', limit: 8 )
		end
		[caption, orders]
	end

	def self.summary_by_date(release_id)
		# 指定されたリリースのオーダーの日次集計をとる．
		summary = Hash.new {|h,k| h[k] = Hash.new {|h,k|
			h[k] = Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] = 0}}
		}}
		for order in where([
		"release_id = ? AND state != ?", release_id, STATE_CANCELED ])
			for li in order.current_line_items
				mkey = sprintf('%04d/%02d', order.due_year, order.due_month )
				dkey = sprintf('%02d/%02d', order.due_month, order.due_day )
				summary[mkey][dkey][li.product_id][:total] += li.quantity
				if order.delivered?
					summary[mkey][dkey][li.product_id][:delivered] += li.quantity
				else
					summary[mkey][dkey][li.product_id][:remained] += li.quantity
				end
			end
		end
		summary
	end

	def self.upgrade
		# order の release_id を設定する．
		p_ids = Hash.new {|h,k| h[k] = Array.new(0)}
		for i in Menuitem.all
			p_ids[i.release_id] << i.product_id
		end
		for order in Order.all
			product_ids = []
			for li in order.line_items
				product_ids << li.product_id
			end
			product_ids = product_ids.uniq
			release_ids = []
			for release_id in p_ids.keys()
				if (product_ids - p_ids[release_id]).length <= 0
					release_ids << release_id
				end
			end
			if release_ids.length == 1
				order.release_id = release_ids[0]
				order.save!
			else
				p order.id.to_s + " : " + release_ids.to_s
			end
		end
	end

	def weekday
		wday = '日月火水木金土'[Time.local(due_year, due_month, due_day ).wday]
	end

	def current_line_items
		items = line_items.where(["ordered_at = ?", ordered_at])
	end

	def canceled?
		return (state == STATE_CANCELED)
	end

	def delivered!
		self.amount_paid = total_price
		self.balance = total_price - amount_paid
		self.state = STATE_DELIVERED
		self
	end

	def delivered?
		state == STATE_DELIVERED
	end

	def normal!
		self.state = STATE_NORMAL
		self
	end

	def normal?
		state == STATE_NORMAL
	end

	def toggle!
		delivered? or self.state = (normal? ? STATE_CANCELED : STATE_NORMAL )
		self
	end

	def replicate_line_items(items)
		for item in items
			li = item.clone
			li.ordered_at = ordered_at
			li.save
		end
	end

	def build_due
		# due_year, due_month, due_day, due_hour, due_minute から due を特定する．
		due.change(:year => due_year, :month => due_month, :day => due_day,
			:hour => due_hour, :min => due_minute )
	end

end
