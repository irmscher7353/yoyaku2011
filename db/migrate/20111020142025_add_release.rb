# vim:ts=2:sw=2
class AddRelease < ActiveRecord::Migration
	@@release = "2009-12"
  def up
		add_column :titles, :release, :string, :default => ''
		add_column :products, :release, :string, :default => ''
		for title in Title.find(:all)
			title.release = @@release
			title.save
		end
		for product in Product.find(:all)
			product.release = @@release
			product.save
		end
  end

  def down
		remove_column :titles, :release
		remove_column :products, :release
  end
end
