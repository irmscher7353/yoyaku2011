# -*- coding: utf-8 -*-
class Release < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	has_many :menuitems, dependent: :destroy

	def self.current()
		ordered.first()
	end

	def self.first_or_create(name)
		where(name: name).first or create(name: name)
	end

	def self.ordered()
		order('created_at DESC')
	end
end
