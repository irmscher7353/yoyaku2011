class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name, null: false, default: ''

      t.timestamps
    end
  end
end
