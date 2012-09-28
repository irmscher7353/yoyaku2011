# encoding: utf-8
# vim:ts=2:sw=2
class Order < ActiveRecord::Base
	has_many :line_items

	def weekday
		wday = '日月火水木金土'[Time.local(due_year, due_month, due_day ).wday]
	end

	def current_line_items
		items = line_items.where(["ordered_at = ?", ordered_at])
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
