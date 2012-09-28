# vim:ts=2:sw=2
class ApplicationController < ActionController::Base
  protect_from_forgery

	Time::DATE_FORMATS[:ja_date] = "%Y/%m/%d %H:%M"
	
end
