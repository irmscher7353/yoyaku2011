# vim:ts=2:sw=2
class AddMeans < ActiveRecord::Migration
  def up
  	add_column :orders, :means, :string, :default => ''
  end

  def down
  	remove_column :orders, :means
  end
end
