#!/usr/bin/env ruby

require "date"
require 'optparse'

params = ARGV.getopts("y:", "m:")
today = Date.today
year =
if params["y"]
    params["y"].to_i
else
  today.year
end

month =
if params["m"]
    params["m"].to_i
else
  today.mon
end


title = month.to_s + "月 " + year.to_s
firstday_wday = Date.new(year,month,1).wday
lastday_date = Date.new(year,month,-1).day
week = "日 月 火 水 木 金 土"

puts title.center(20)
puts week
print "   " * firstday_wday 
(1..lastday_date).each do |date|
  print date.to_s.rjust(2) + " "
  firstday_wday += 1
  if firstday_wday % 7 == 0
    print "\n"
  end
end
print "\n"
