class AddTotalPriceAndPayment < ActiveRecord::Migration
  def up
  	add_column :orders, :total_price, :integer
	add_column :orders, :payment, :string
  end

  def down
  	remove_column :orders, :payment
	remove_column :orders, :total_price
  end
end
