class CreateNames < ActiveRecord::Migration
  def change
    create_table :names do |t|
      t.string :sei, :default => ''
      t.string :mei, :default => ''

      t.timestamps
    end
  end
end
