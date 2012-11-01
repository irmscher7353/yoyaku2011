class AddPriorityToTitles < ActiveRecord::Migration
  def change
    add_column :titles, :priority, :integer, default: 55
  end
end
