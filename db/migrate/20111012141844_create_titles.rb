class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :title, :default => ''
      t.text :description, :default => ''
      t.string :image_url, :default => ''

      t.timestamps
    end
  end
end
