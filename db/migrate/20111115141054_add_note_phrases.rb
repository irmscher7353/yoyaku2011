# encoding: utf-8
# vim:ts=2:sw=2
class AddNotePhrases < ActiveRecord::Migration
  def up
  	name = '備考欄の常套句'
		if Preference.where(["name = ?", name]).size == 0
			Preference.create(:name => name, :value =>
			"おたんじょうびおめでとう\nHappy Birthday" )
		end
  end

  def down
  end
end
