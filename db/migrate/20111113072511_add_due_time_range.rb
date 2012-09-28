# encoding: utf-8
# vim:ts=2:sw=2
class AddDueTimeRange < ActiveRecord::Migration
  def up
		name = '予約伝票の注記'
  	if Preference.where(["name = ?", name ]).size == 0
			Preference.create(:name => name, :value =>
			'上記の通りご予約承りました。ご来店の際は、お客様控えをお持ち下さい。' )
		end

		name = '引渡し開始時間'
  	if Preference.where(["name = ?", name ]).size == 0
			Preference.create(:name => name, :value => '10:00' )
		end

		name = '引渡し終了時間'
  	if Preference.where(["name = ?", name ]).size == 0
			Preference.create(:name => name, :value => '20:00' )
		end
  end

  def down
  end
end
