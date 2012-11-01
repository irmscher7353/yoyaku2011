class Title < ActiveRecord::Base
	has_many :products

	def self.find_titles_for_sale
		where(["on_sale = ?", true]).order("priority, id")
	end
end
