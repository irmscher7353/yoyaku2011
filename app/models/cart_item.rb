# vim:ts=2:sw=2
class CartItem
	attr_reader :product, :quantity

	def self.from_line_item(line_item)
		ci = self.new(line_item.product, line_item.quantity)
	end

	def initialize(product = nil, quantity = 0)
		@product = product
		@quantity = quantity
	end

	def increment_quantity(quantity)
		@quantity += quantity
	end

	def title
		@product.title
	end

	def price
		if @product
			price = @product.price * @quantity
		else
			price = 0
		end
		price
	end

end
