class CreateMenuitems < ActiveRecord::Migration
  def change
    create_table :menuitems do |t|
      t.integer :release_id
      t.integer :product_id

      t.timestamps
    end
  end
end
