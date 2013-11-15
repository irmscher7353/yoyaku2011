class Product < ActiveRecord::Base
	belongs_to :release
	belongs_to :title
	has_many :line_items

	def self.find_products_for_sale
		products = []
		for product in where(["on_sale = ?", true]).order("title_id, price")
			products << product if product.title.on_sale
		end
		products
	end
end
