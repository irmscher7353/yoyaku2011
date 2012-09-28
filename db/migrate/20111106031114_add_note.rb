class AddNote < ActiveRecord::Migration
  def up
    add_column :orders, :note, :text, :default => ''
  end

  def down
    remove_column :orders, :note
  end
end
