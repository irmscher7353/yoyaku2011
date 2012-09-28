# vim:ts=2:sw=2
class Cart
	attr_reader :name, :phone, :address, :items

	def initialize
		@name = ""
		@phone = ""
		@address = ""
		@items = []
	end

	def add_product(product, quantity)
		current_item = @items.find {|item| item.product == product}
		if current_item
			current_item.increment_quantity(quantity)
		else
			@items << CartItem.new(product, quantity)
		end
	end

	def total_price
		@items.sum {|item| item.price}
	end

end
