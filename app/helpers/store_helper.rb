# encoding: utf-8
# vim:ts=2:sw=2
module StoreHelper
	def barcode(order_id)
		data = sprintf("%05d", order_id )
		bc = Barby::Code39::new(data)
		bc.to_html(:height => 32 ).gsub(/\[\"([^\]]+)\"\]/, '\1').gsub(/\\(\")/, '\1').gsub(/<style>.*<\/style>[\r\n]*/m, '')
	end
end
