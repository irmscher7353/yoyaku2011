class CreateReleases < ActiveRecord::Migration
  def up
    create_table :releases do |t|
      t.string :name, null: false, default: ''
			t.boolean :on_sale, null: false, default: false

      t.timestamps
    end
		Product.all.each do |p|
			release = p.release.split('/').join('-')
			if p.release != release
				p.release = release
				p.save!
			end
			Release.first_or_create(p.release)
		end
  end

	def down
		drop_table :releases
	end
end
