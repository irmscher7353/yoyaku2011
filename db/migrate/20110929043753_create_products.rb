class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, :default => ''
      t.string :size, :default => ''
      t.integer :price
      t.integer :remain

      t.timestamps
    end
  end
end
