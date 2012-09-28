class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string :name, :null => false
      t.text :value, :default => ''

      t.timestamps
    end
  end
end
