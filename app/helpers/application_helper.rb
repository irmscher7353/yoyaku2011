# encoding: utf-8
# vim:ts=2:sw=2
module ApplicationHelper
	def i_to_datetime(i)
		DateTime.new(1970,1,1).since(i)
	end
	def i_to_datetime_s(i,format)
		i_to_datetime(i).to_formatted_s(format)
	end
	def i_to_day(i)
		i_to_datetime(i).day
	end
	def i_to_month(i)
		i_to_datetime(i).month
	end
	def i_to_year(i)
		i_to_datetime(i).year
	end
end
