# vim:ts=2:sw=2
class AddOnSale < ActiveRecord::Migration
  def up
  	add_column :titles, :on_sale, :boolean, :default => true
  	add_column :products, :on_sale, :boolean, :default => true
  end

  def down
  	remove_column :products, :on_sale
  	remove_column :titles, :on_sale
  end
end
