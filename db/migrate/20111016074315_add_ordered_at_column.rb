# vim:ts=2:sw=2
class AddOrderedAtColumn < ActiveRecord::Migration
  def up
  	add_column :line_items, :ordered_at, :datetime
		for order in Order.find(:all)
			for item in order.line_items
				item.ordered_at = order.updated_at
				item.save
			end
		end
  end

  def down
		remove_column :line_items, :ordered_at
  end
end
