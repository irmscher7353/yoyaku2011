class AddReleaseToOrders < ActiveRecord::Migration
  def up
		add_column :orders, :release_id, :integer, null: false, default: 0
		Order.upgrade
  end

	def down
		remove_column :orders, :release_id
	end
end
