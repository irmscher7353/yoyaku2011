# encoding: utf-8
# vim:ts=2:sw=2
class AddLimitation < ActiveRecord::Migration
  def up
		add_column :products, :limitation, :integer, default: -1
		count = Hash.new(0)
		for order in Order.where(["STATE != ?", "キャンセル" ])
			for line_item in order.current_line_items
				count[line_item.product_id] += line_item.quantity
			end
		end
		for product in Product.find(:all)
			product.limitation = product.remain
			if 0 <= product.remain
				product.limitation += count[product.id]
			end
			product.save
		end
  end

  def down
		remove_column :products, :limitation
  end
end
