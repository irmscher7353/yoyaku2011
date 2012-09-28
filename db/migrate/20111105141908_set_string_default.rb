# vim:ts=2:sw=2
class SetStringDefault < ActiveRecord::Migration
  def up
  	for order in Order.find(:all)
			modified = 0
			if order.name == nil
				order.name = ''
				modified += 1
			end
			if order.phone == nil
				order.phone = ''
				modified += 1
			end
			if order.address == nil
				order.address = ''
				modified += 1
			end
			if order.payment == nil
				order.payment = ''
				modified += 1
			end
			if order.means == nil
				order.means = ''
				modified += 1
			end
			if order.state == nil
				order.state = ''
				modified += 1
			end
			if 0 < modified
				order.save
			end
		end
		for product in Product.find(:all)
			modified = 0
			if product.old_title == nil
				product.old_title = ''
				modified += 1
			end
			if product.size == nil
				product.size = ''
				modified += 1
			end
			if product.release == nil
				product.release = ''
				modified += 1
			end
			if 0 < modified
				product.save
			end
		end
		for title in Title.find(:all)
			modified = 0
			if title.title == nil
				title.title = ''
				modified += 1
			end
			if title.description == nil
				title.description = ''
				modified += 1
			end
			if title.image_url == nil
				title.image_url = ''
				modified += 1
			end
			if title.release == nil
				title.release = ''
				modified += 1
			end
			if 0 < modified
				title.save
			end
		end
  end

  def down
  end
end
