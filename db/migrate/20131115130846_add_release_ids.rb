# -*- coding: utf-8 -*-
class AddReleaseIds < ActiveRecord::Migration
  def up
		add_column :titles, :release_id, :integer, null: false, default: 0
		Title.all.each do |t|
			t.release = t.release.gsub(/\//, '-')
			t.release_id = Release.first_or_create(t.release).id
			t.save!
		end
		add_column :products, :release_id, :integer, null: false, default: 0
		Product.all.each do |p|
			p.release = p.release.gsub(/\//, '-')
			p.release_id = Release.first_or_create(p.release).id
			p.save!
		end
		remove_column :titles, :release
		remove_column :products, :release
  end

  def down
		add_column :titles, :release, :string, default: ''
		Title.all.each do |t|
			t.release = Release.find(t.release_id).name
			t.save!
		end
		add_column :products, :release, :string, default: ''
		Product.all.each do |p|
			p.release = Release.find(p.release_id).name
			p.save!
		end
		remove_column :titles, :release_id
		remove_column :products, :release_id
  end
end
