# encoding: utf-8
# vim:ts=2:sw=2
class AddTitlesAndProducts201112 < ActiveRecord::Migration
	@@release = "2011/12"
	@@titles = {
		"いちごデコレーション" => {
			"5号" => 2700, "6号" => 3400, "7号" => 4300, "8号" => 6500, "10号" => 12600
		},
		"チョコデコレーション" => {
			"5号" => 2700, "6号" => 3400, "7号" => 4300, "8号" => 6500, "10号" => 12600
		},
		"スペシャルデコレーション" => {
			"6号" => 3800
		},
		"いちごとチョコのハーフ" => {
			"6号" => 3800
		},
		"ビッシュ・ド・ノエル キャラメル" => {
			"" => 3150
		},
		"タルトフレーズ" => {
			"5号" => 3150
		},
		"ティラミスタルト" => {
			"5号" => 2700
		},
		"ツインデコ" => {
			"4号" => 3800
		},
		"チーズタルト" => {
			"6号" => 2800
		},
		"フォンダンショコラ" => {
			"6号" => 3150
		},
		"クリスマス・シフォン" => {
			"5号" => 2300
		},
		"クリスマス・レインボー" => {
			"6号サイズ" => 2600
		},
		"クリスマス・パーティーピッツア" => {
			"" => 0
		},
		"クリスマス・スペシャルキッシュ" => {
			"" => 0
		},
		"フライドチキン" => {
			"" => 0
		}
	}

  def up
		for title in Title.find(:all)
			unless @@titles.has_key?(title.title)
				title.on_sale = false
				title.save
			end
		end
		@@titles.each { |title, h|
			title = Title.where(["title = ?", title]).first || Title.create(:title => title, :release => @@release )
			for product in title.products.where(["release != ?", @@release ])
				product.on_sale = false
				product.save
			end
			h.each { |size, price|
				Product.create(:title_id => title.id, :size => size, :release => @@release,
						:price => price, :on_sale => (0 < price), :remain => -1 )
			}
		}
  end

  def down
		for product in Product.where(["release = ?", @@release ])
			product.delete
		end
		for title in Title.where(["release = ?", @@release ])
			title.delete
		end
  end
end
