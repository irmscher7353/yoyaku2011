# encoding: utf-8
# vim:ts=2:sw=2
class AddTestData < ActiveRecord::Migration
  def up
  	Product.delete_all

		Product.create(:title => 'いちごデコレーション', :size => '5号', :price => 2625, :remain => -1)
		Product.create(:title => 'いちごデコレーション', :size => '6号', :price => 3360, :remain => -1)
		Product.create(:title => 'いちごデコレーション', :size => '7号', :price => 4200, :remain => -1)
		Product.create(:title => 'いちごデコレーション', :size => '8号', :price => 6300, :remain => -1)
		Product.create(:title => 'いちごデコレーション', :size => '10号', :price => 12600, :remain => -1)
		Product.create(:title => 'いちごデコレーション', :size => 'パーティサイズ', :price => 26250, :remain => -1)

		Product.create(:title => 'チョコデコレーション', :size => '5号', :price => 2625, :remain => -1)
		Product.create(:title => 'チョコデコレーション', :size => '6号', :price => 3360, :remain => -1)
		Product.create(:title => 'チョコデコレーション', :size => '7号', :price => 4200, :remain => -1)
		Product.create(:title => 'チョコデコレーション', :size => '8号', :price => 6300, :remain => -1)
		Product.create(:title => 'チョコデコレーション', :size => '10号', :price => 12600, :remain => -1)
		Product.create(:title => 'チョコデコレーション', :size => 'パーティサイズ', :price => 26250, :remain => -1)

		Product.create(:title => 'ティラミスタルト', :size => '', :price => 2625, :remain => -1)

		Product.create(:title => 'いちごタルト', :size => '', :price => 3200, :remain => -1)

		Product.create(:title => 'スペシャルデコレーション', :size => '', :price => 4200, :remain => -1)

		Product.create(:title => 'ツインデコ', :size => '', :price => 3800, :remain => -1)

		Product.create(:title => 'ビッシュドノエル いちご', :size => '', :price => 3200, :remain => -1)

		Product.create(:title => 'ビッシュドノエル キャラメルポワール', :size => '', :price => 3200, :remain => -1)

		Product.create(:title => 'モンブラン', :size => '', :price => 3500, :remain => -1)

		Product.create(:title => 'スフレ ショコラ', :size => '', :price => 3150, :remain => -1)

		Product.create(:title => 'ピッツア', :size => '', :price => 1890, :remain => -1)

		Product.create(:title => 'チキン', :size => '', :price => 1000, :remain => -1)

  end

  def down
  	Product.delete_all
  end
end
