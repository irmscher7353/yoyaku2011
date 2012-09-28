class AddDueFields < ActiveRecord::Migration
  def up
  	add_column :orders, :due_year, :integer, :default => Date.today.year
	add_column :orders, :due_month, :integer, :default => 12
	add_column :orders, :due_day, :integer
	add_column :orders, :due_hour, :integer
	add_column :orders, :due_minute, :integer, :default => 0
  end

  def down
  	remove_column :orders, :due_year
  	remove_column :orders, :due_month
  	remove_column :orders, :due_day
  	remove_column :orders, :due_hour
  	remove_column :orders, :due_minute
  end
end
