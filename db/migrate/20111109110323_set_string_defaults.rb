# vim:ts=2:sw=2
class SetStringDefaults < ActiveRecord::Migration
  def up
  	change_column_default :orders, :name, ""
  	change_column_default :orders, :phone, ""
  	change_column_default :orders, :address, ""
  	change_column_default :orders, :payment, ""
  	change_column_default :orders, :means, ""
  	change_column_default :orders, :state, ""

  	change_column_default :products, :old_title, ""
  	change_column_default :products, :size, ""
  	change_column_default :products, :release, ""

  	change_column_default :titles, :title, ""
  	change_column_default :titles, :description, ""
  	change_column_default :titles, :image_url, ""
  	change_column_default :titles, :release, ""
  end

  def down
  end
end
