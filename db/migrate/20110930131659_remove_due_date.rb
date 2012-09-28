class RemoveDueDate < ActiveRecord::Migration
  def up
  	remove_column :orders, :due_date
	rename_column :orders, :due_time, :due
	change_column :orders, :due, :datetime, :default => Date.today.change(:month => 12, :day => 24, :hour => 12, :minute => 0, :second => 0)
  end

  def down
  	change_column :orders, :due, :time
	rename_column :orders, :due, :due_time
  	add_column :orders, :due_date, :date
  end
end
