# vim:ts=2:sw=2
class AddTitleId < ActiveRecord::Migration
  def up
		rename_column :products, :title, :old_title
  	add_column :products, :title_id, :integer
		for product in Product.find(:all)
			product.title_id = Title.where(["title = ?", product.old_title ]).first.id
			product.save
		end
  end

  def down
		for product in Product.find(:all)
			product.old_title = Title.find(product.title_id).title
			product.save
		end
  	remove_column :products, :title_id
		rename_column :products, :old_title, :title
  end
end
