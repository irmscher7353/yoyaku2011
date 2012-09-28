# encoding: utf-8
# vim:ts=2:sw=2
class AddStateAndBalance < ActiveRecord::Migration
  def up
		add_column :orders, :amount_paid, :integer, :default => 0
		add_column :orders, :balance, :integer, :default => 0
		add_column :orders, :state, :string, :default => ''
		for order in Order.find(:all)
			if order.payment == "済"
				order.amount_paid = order.total_price
				order.save
			end
		end
  end

  def down
		remove_column :orders, :state
		remove_column :orders, :balance
		remove_column :orders, :amount_paid
  end
end
