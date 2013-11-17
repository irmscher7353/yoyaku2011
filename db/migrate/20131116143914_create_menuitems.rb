class CreateMenuitems < ActiveRecord::Migration
  def up
    create_table :menuitems do |t|
      t.integer :release_id
      t.integer :product_id

      t.timestamps
    end
		Product.all.each do |p|
			Menuitem.create(
				release_id: Release.first_or_create(p.release).id, product_id: p.id )
		end
  end
	def down
		drop_table :menuitems
	end
end
