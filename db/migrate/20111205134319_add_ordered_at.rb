# vim:ts=2:sw=2
class AddOrderedAt < ActiveRecord::Migration
  def up
  	add_column :orders, :ordered_at, :datetime
		for order in Order.find(:all)
			order.ordered_at = order.updated_at
			order.save
		end
  end

  def down
		remove_column :orders, :ordered_at
  end
end
