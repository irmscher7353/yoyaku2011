class CreateNames < ActiveRecord::Migration
  def change
    create_table :names do |t|
      t.string :sei
      t.string :mei

      t.timestamps
    end
  end
end
