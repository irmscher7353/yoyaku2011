# -*- coding: utf-8 -*-
class Product < ActiveRecord::Base
	belongs_to :title
	has_many :line_items
	has_many :menuitems
	before_destroy :ensure_not_referenced

	def self.compare(a,b)
		a.title_id == b.title_id ? a.price <=> b.price :
		a.title.priority == b.title.priority ? a.title_id <=> b.title_id :
		a.title.priority <=> b.title.priority
	end

	def self.find_by_release(release_id)
		product_ids = []
		for mi in Menuitem.find_by_release(release_id)
			product_ids << mi.product_id
		end
		where(["id in (?)", product_ids.uniq]).sort {|a,b| compare(a,b)}
	end

	def self.find_products_for_sale
		products = []
		for product in where(["on_sale = ?", true]).sort {|a,b| compare(a,b)}
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
