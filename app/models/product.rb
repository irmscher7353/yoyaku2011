# -*- coding: utf-8 -*-
class Product < ActiveRecord::Base
	belongs_to :title
	has_many :line_items
	has_many :menuitems
	before_destroy :ensure_not_referenced

	def self.find_products_for_sale
		products = []
		for product in where(["on_sale = ?", true]).order("title_id, price")
			products << product if product.title.on_sale
		end
		products
	end

	def label
		title.title + ' - ' + size
	end

	private

	def ensure_not_referenced
		if not line_items.empty?
			errors.add(:base, '購入履歴が残っている商品は削除できません！')
			return false
		end
		if not menuitems.empty?
			errors.add(:base, 'メニューで使われている商品は削除できません！')
			return false
		end
		return true
	end
end
