# encoding: utf-8
# vim:ts=2:sw=2
class AddTitles < ActiveRecord::Migration
  def up

  	Title.delete_all

		Title.create(:title => 'いちごデコレーション', :description => %{
		ふわふわスポンジに真っ白いクリームと真っ赤ないちご。<br/>
		みんな大好きいちごのケーキ。
		})
		Title.create(:title => 'チョコデコレーション', :description => %{
		})
		Title.create(:title => 'ティラミスタルト', :description => %{
		})
		Title.create(:title => 'いちごタルト', :description => %{
		})
		Title.create(:title => 'スペシャルデコレーション', :description => %{
		})
		Title.create(:title => 'ツインデコ', :description => %{
		})
		Title.create(:title => 'ビッシュドノエル いちご', :description => %{
		})
		Title.create(:title => 'ビッシュドノエル キャラメルポワール', :description => %{
		})
		Title.create(:title => 'モンブラン', :description => %{
		})
		Title.create(:title => 'スフレ ショコラ', :description => %{
		})
		Title.create(:title => 'ピッツア', :description => %{
		})
		Title.create(:title => 'チキン', :description => %{
		})
  end

  def down
		Title.delete_all
  end
end
