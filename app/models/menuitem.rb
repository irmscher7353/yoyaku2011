class Menuitem < ActiveRecord::Base
	belongs_to :release
	belongs_to :product
end
