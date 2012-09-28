class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name, :default => ''
      t.string :phone, :default => ''
      t.string :address, :default => ''
      t.date :due_date
      t.time :due_time

      t.timestamps
    end
  end
end
