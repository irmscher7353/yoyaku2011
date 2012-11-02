# coding: utf-8
# vim:sw=2:ts=2
class Name < ActiveRecord::Base

  def self.from_string(str)
    f = str.split("　")
    if f.length == 2
      name = self.new(sei: f[0], mei: f[1] )
    else
      name = self.new(sei: str, mei: "" )
    end
    name
  end

end
