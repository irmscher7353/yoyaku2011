class ChangeRemainDefault < ActiveRecord::Migration
  def up
  	change_column_default :products, :remain, -1
  end

  def down
  	change_column_default :products, :remain, nil
  end
end
