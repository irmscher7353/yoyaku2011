class CreateMenuitems < ActiveRecord::Migration
  def up
    create_table :menuitems do |t|
      t.integer :release_id
      t.integer :product_id

      t.timestamps
    end
		Menuitem.generate
  end

	def down
		drop_table :menuitems
	end
end
