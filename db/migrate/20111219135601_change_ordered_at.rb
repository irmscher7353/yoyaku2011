# encoding: utf-8
# vim:ts=2:sw=2
class ChangeOrderedAt < ActiveRecord::Migration
  def up
		add_column :orders, :ordered_at_i, :integer
		add_column :line_items, :ordered_at_i, :integer
		for order in Order.find(:all)
			order.ordered_at_i = order.ordered_at.to_i
			order.save
		end
		for line_item in LineItem.find(:all)
			line_item.ordered_at_i = line_item.ordered_at.to_i
			line_item.save
		end
		remove_column :orders, :ordered_at
		remove_column :line_items, :ordered_at
		add_column :orders, :ordered_at, :integer
		add_column :line_items, :ordered_at, :integer
		for order in Order.find(:all)
			order.ordered_at = order.ordered_at_i
			order.save
		end
		for line_item in LineItem.find(:all)
			line_item.ordered_at = line_item.ordered_at_i
			line_item.save
		end
		remove_column :orders, :ordered_at_i
		remove_column :line_items, :ordered_at_i
  end

  def down
  end
end
