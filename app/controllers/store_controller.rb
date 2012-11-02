# encoding: utf-8
# vim:ts=2:sw=2
class StoreController < ApplicationController

	MIN_LINES = 5

	STATE_NORMAL = ''
	STATE_CANCELED = 'キャンセル'
	STATE_DELIVERED = '引渡し済み'

	def check
		# ordered_at 導入前のバグで，古いはずの line_items が古くなっていない
		# order を検出する．

		@invalid_orders = []
		@suspicious_orders = []
		@multiline_orders = []

		for order in Order.where(["state = ? ", STATE_NORMAL ])
			total = 0
			count = Hash.new(0)
			for li in order.current_line_items
				total += li.total_price
				count[li.product_id] += 1
			end
			if total != order.total_price
				@invalid_orders << order
			end
			count.each do |productid, num|
				if 1 < num
					@suspicious_orders << order
				end
			end
			if 1 < count.size
				@multiline_orders << order
			end
		end

		respond_to do |format|
			format.html # check.html.erb
		end
	end

	def define_constants
		# 何故かクラス定数やクラス変数が views/store/_form.html.erb からアクセス
		# できない．．．
		@kana = [
			"アイウエオ", "ァィゥェォ",
			"カキクケコ", "ガギグゲゴ",
			"サシスセソ", "ザジズゼゾ",
			"タチツテト", "ダヂヅデド",
			"ナニヌネノ",
			"ハヒフヘホ", "バビブベボ", "パピプペポ",
			"マミムメモ",
			"ヤ　ユ　ヨ", "ャ　ュ　ョ",
			"ラリルレロ",
			"ワ　ッヲン"
			]
		@numbers = [
			"123", "456", "789", "-0←"
			]
		@remain = []
		for product in Product.find(:all)
			@remain[product.id] = product.remain
		end
		p = Preference.where(["name = ?", '引渡し開始時間' ]).last
		@due_time_min = p ? p.value : '10:00'
		p = Preference.where(["name = ?", '引渡し終了時間' ]).last
		@due_time_max = p ? p.value : '20:00'
		p = Preference.where(["name = ?", '備考欄の常套句' ]).last
		@note_phrases = p ? p.value.split(/[\r\n]+/) : []

		date_string = '2000/01/01 '
		due_time_min = Time.parse(date_string + @due_time_min )
		due_time_max = Time.parse(date_string + @due_time_max )
		@due_hours = due_time_min.hour .. due_time_max.hour
	end

	def index
		@orders_found = []
		@recent_orders = []
		if params[:id] || params[:name] || params[:phone] || params[:due_month] || params[:due_day] || params[:means] || params[:state]
			if params[:id] == ''
				@orders_found = Order.where([
					"name LIKE ? AND phone LIKE ? AND due_month LIKE ? AND due_day LIKE ? AND means LIKE ? AND state LIKE ?", 
					"%#{params[:name]}%",
					"%#{params[:phone]}%",
					"%#{params[:due_month]}%",
					"%#{params[:due_day]}%",
					"%#{params[:means]}%",
					"%#{params[:state]}%" ])
			else
				@orders_found << Order.find(params[:id].to_i)
			end
			@caption = "予約の検索結果"
			if @orders_found.size <= 0
				@message = "指定された条件に合う予約は見つかりませんでした．"
			else
				@message = ""
			end
		else
			@recent_orders = Order.where(["state = ? AND due_year = ? AND due_month = ? AND due_day = ?", STATE_NORMAL, Time.current.year, Time.current.month, Time.current.day ]).order('due ASC').limit(16)
			@caption = "今日の予約"
			if @recent_orders.size <= 0
				@recent_orders = Order.find(:all, :order => "ordered_at DESC", :limit => 8)
				@caption = "最近更新した予約"
			end
			@message = "予約番号を指定すると，他の検索条件は無視されます．"
		end

		selected = ' selected="selected"'

		respond_to do |format|
			format.html # index.html.erb
		end
	end

  def new
		define_constants

		@titles = Title.find_titles_for_sale
		@order = find_order
		@order_disabled = @order.state && @order.state != STATE_NORMAL
		@cart = find_cart
		@seimei = []

		respond_to do |format|
			format.html # new.html.erb
		end
  end

	def add_to_cart(product_id, quantity)
		product = Product.find(product_id)
		@cart.add_product(product, quantity)
	end

	def cancel_order
		# order の STATE_CANCELED <=> STATE_NORMAL をトグルさせる．
		@order = Order.find(params[:order][:id].to_i)
		if @order.state == STATE_DELIVERED
			redirect_to :action => :edit, :id => @order.id
			return
		end
		@order.state = @order.state == STATE_NORMAL ? STATE_CANCELED : STATE_NORMAL
		line_items = @order.current_line_items
		quantity_delta = Hash.new(0)
		sign = @order.state == STATE_NORMAL ? -1 : 1
		for li in line_items
			quantity_delta[li.product_id] = sign * li.quantity
		end
		unless keep_products(quantity_delta)
			redirect_to :action => :edit, :id => @order.id
			return
		end
		if @order.save
			session[:cart] = nil
			session[:order] = nil
			redirect_to :action => :edit, :id => @order.id
		else
			logger.error(sprintf("Failed to save order %d.", @order.id))
			redirect_to :action => :edit, :id => @order.id
		end
	end

	def deliver_order
		if 0 < (order_id = params[:order][:id].to_i)
			@order = Order.find(order_id)
			@order.state = STATE_DELIVERED
			@order.amount_paid = @order.total_price
			@order.balance = 0
			if @order.save
				session[:cart] = nil
				session[:order] = nil
				redirect_to :action => :edit, :id => @order.id
			else
				logger.error(sprintf("Failed to save order %d.", @order.id))
				redirect_to :action => :edit, :id => @order.id
			end
		end
	end

	def edit
		define_constants

		unless params[:id]
			redirect_to :action => :index
			return
		end
	
		@titles = Title.find_titles_for_sale
		@order = Order.find('%i' % params[:id])
		@cart = Cart.new
		for line_item in @order.current_line_items
			@cart.items << CartItem.from_line_item(line_item)
			if 0 <= @remain[line_item.product_id]
				@remain[line_item.product_id] += line_item.quantity
			end
		end
		while @cart.items.length < MIN_LINES
			@cart.items << CartItem.new
		end
		@seimei = []

		respond_to do |format|
			format.html # edit.html.erb
		end
	end

	def empty_cart
		session[:cart] = nil
		session[:order] = nil
		redirect_to :action => 'index'
	end

	def save_order
		quantity_delta = Hash.new(0)
		if (order_id = params[:order][:id].to_i) <= 0
			@order = Order.new(params[:order])
		else
			@order = Order.find(order_id)
			@order.attributes = params[:order]
			for li in @order.current_line_items
				quantity_delta[li.product_id] += li.quantity
			end
		end
		line_items = []
		for i in 1 .. params[:subtotal].length
			itext = '%i' % i
			next if params[:subtotal][itext].to_i <= 0
			productid = params[:productid][itext].to_i
			quantity_delta[productid] -= params[:quantity][itext].to_i
			li = LineItem.new
			li.order = @order
			li.product_id = productid
			li.quantity = params[:quantity][itext].to_i
			li.total_price = params[:subtotal][itext].to_i
			line_items << li
		end

		unless keep_products(quantity_delta)
			if order_id <= 0
				redirect_to :action => :new
			else
				redirect_to :action => :edit, :id => order_id
			end
			return
		end

		@order.ordered_at = DateTime.current.to_i
		@order.due = @order.build_due
		@order.total_price = params[:total]
		@order.means = params[:means]
		@order.payment = params[:payment]
		if @order.payment == "済"
			@order.amount_paid = @order.total_price
		end
		@order.balance = @order.total_price - @order.amount_paid
		@order.state = STATE_NORMAL

		if @order.save
			@order.replicate_line_items(line_items)
			session[:cart] = nil
			session[:order] = nil
			logger.error('@order.save success')
			Name.from_string(@order.name).save
			#redirect_to :action => 'index'
			redirect_to :action => :show, :id => @order.id
		else
			logger.error('@order.save failed')
			if order_id <= 0
				redirect_to :action => :new
			else
				redirect_to :action => :edit, :id => order_id
			end
		end
	end

	def seimei

		@seimei = []

		if params[:name] and params[:name] != ""
			str = params[:name]
			if str =~ /　/
				sei, mei = str.split("　")
				if mei == nil or mei == ""
					for name in Name.where(
						['sei = ?', sei ]).group('mei').order('mei')
						if name.mei != ""
							@seimei << name.mei
						end
					end
				else
					for name in Name.where(
						['mei like ?', "#{mei}%" ]).group('mei').order('mei')
						if name.mei != ""
							@seimei << name.mei
						end
					end
				end
			else
				for name in Name.where(
					['sei like ?', "#{str}%" ]).group('sei').order('sei')
					if name.sei != ""
						@seimei << name.sei
					end
				end
			end
		end

		respond_to do |format|
			format.js
		end
	end

	def show
		if params[:id]
			@order = Order.find(params[:id].to_i)
		else
			@order = find_order
		end
		unless @order.id
			redirect_to :action => :index
			return
		end
		pref = Preference.where(["name = ?", '予約伝票の注記' ]).last
		if pref
			@conclusion = pref.value.gsub(/\n/, '<br/>').html_safe
		else
			@conclusion = ''
		end
		ordered_products = []
		for li in @order.line_items
			ordered_products << li.product.id
		end
		@reminder = []
		for product in Product.find_products_for_sale
			if 0 <= product.remain and product.remain < 10
				if 0 < product.remain
					classname = "remain"
					remain = product.remain
				else
					if ordered_products.include?(product.id)
						classname = "just_soldout"
						remain = "完売しました"
					else
						classname = "soldout"
						remain = "完売"
					end
				end
				@reminder << { product: product, remain: remain, classname: classname }
			end
		end
		respond_to do |format|
			format.html # show.html.erb
		end
	end

	def summary

		if params[:mkey] && params[:dkey]
			@line_items = []
			@summary = Hash.new {|h,k| h[k]=Hash.new (0)}
			yyyy, mm = params[:mkey].split('/')
			mm, dd = params[:dkey].split('/')
			@caption = yyyy + '-' + mm + '-' + dd
			for order in Order.where(["state = ? AND due_year = ? AND due_month = ? AND due_day = ?", STATE_NORMAL, yyyy.to_i, mm.to_i, dd.to_i ]).order('due ASC')
				for li in order.current_line_items
					next unless (li.product.on_sale && li.product.title.on_sale)
					tkey = sprintf('%02d:%02d', order.due_hour, order.due_minute )
					@summary[tkey][li.product_id] += li.quantity
					@line_items.push(li)
				end
			end
		else
			@summary = Hash.new {|h,k| h[k]=Hash.new {|hh,kk| hh[kk]=Hash.new {|hhh,kkk| hhh[kkk]=Hash.new(0)}}}
			for order in Order.where(["state != ?", STATE_CANCELED ] )
				for li in order.current_line_items
					next unless (li.product.on_sale && li.product.title.on_sale)
					mkey = sprintf('%04d/%02d', order.due_year, order.due_month )
					dkey = sprintf('%02d/%02d', order.due_month, order.due_day )
					@summary[mkey][dkey][li.product_id][:total] += li.quantity
					@summary[mkey][dkey][li.product_id][order.state == STATE_DELIVERED ? :delivered : :remained] += li.quantity
				end
			end
			@options_tag = ''
			for mkey in @summary.keys.sort.reverse
				@options_tag += sprintf("<option >%s</option>", mkey)
			end
		end

		respond_to do |format|
			format.html # summary.html.erb
		end
	end

private

	def find_cart
		session[:cart] ||= Cart.new
		while session[:cart].items.length < MIN_LINES
			session[:cart].items << CartItem.new
		end
		session[:cart]
	end

	def find_order
		this_eve = Time.mktime(Time.now.year, 12, 24 )
		session[:order] ||= Order.new(due: this_eve, due_year: this_eve.year )
	end

	def keep_products(quantity_delta)
		# キーが productid, 値が数量の増減であるようなハッシュ qunatity_delta を
		# 確保する．

		result = true

		products_to_rollback = []

		quantity_delta.each do |productid, delta|
			next if delta == 0
			product = Product.find(productid)
			next if product.remain < 0
			product.remain += delta
			if product.remain < 0
				logger.error(sprintf('product[%d] shorten %d (%d)', product.id, delta, product.remain ))
				result = false
				break
			end
			if product.save
				products_to_rollback << product
			else
				logger.error(sprintf('product[%d].save failed.', product.id ))
				result = false
				break
			end
		end

		unless result
			for product in products_to_rollback
				product.remain -= quantity_delta[product.id]
				if product.save
				else
					logger.error(sprintf('rollback product[%d].remain = %d failed.', product.id, product.remain ))
					result = false
				end
			end
		end

		result
	end

end
