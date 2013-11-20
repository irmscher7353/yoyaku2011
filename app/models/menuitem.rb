class Menuitem < ActiveRecord::Base
	belongs_to :release
	belongs_to :product

	def self.generate
    h = Hash.new {|h,k| h[k] = Hash.new(0)}
    for li in LineItem.all
      rel = li.created_at.year.to_s + '-' + li.created_at.month.to_s
      h[rel][li.product_id] += 1
    end
		prev_release = Release.current.name
    for p in Product.find_products_for_sale
      h[prev_release][p.id] = 1
    end
    prev_release = ''
    for p in Product.all
      if prev_release != '' and p.release != prev_release
        rel_id = Release.first_or_create(prev_release).id
        h[prev_release].keys.sort {|a,b|
          Product.find(a).title.priority <=> Product.find(b).title.priority or
          a <=> b}.each do |p_id|
          Menuitem.create(release_id: rel_id, product_id: p_id)
        end
        h.delete prev_release
      end
      rel_id = Release.first_or_create(p.release).id
      Menuitem.create(release_id: rel_id, product_id: p.id )
      h[p.release].delete p.id
      prev_release = p.release
    end
    rel_id = Release.first_or_create(prev_release).id
        h[prev_release].keys.sort {|a,b|
          Product.find(a).title.priority <=> Product.find(b).title.priority or
          a <=> b}.each do |p_id|
          Menuitem.create(release_id: rel_id, product_id: p_id )
        end
        h.delete prev_release
	end

end
