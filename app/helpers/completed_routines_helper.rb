=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end

=begin
=end
module CompletedRoutinesHelper
  def month_heading
    @column_layout ||= @person.completed_routines_column_layout
    
#    puts @column_layout
#    puts @routines_layout
    
#    detail_columns = Hash.new(0)
#    @routines_layout.each_with_object(target) do |(date, crs), hash| 
#      crs.each_with_object(hash) do |(date, crs), hash|
##        puts "date: #{date} crs: #{crs.count} crs #{crs.inspect}"
#        hash[date] = [crs.count, hash[date]].max
#      end
#    end
    
#    puts "Target: #{target.inspect}"
    
    by_month = Hash.new(0)
    detail_columns.each_with_object(by_month) do |(date,n), by_month|
      by_month[date.beginning_of_month] += n
    end

    heading = by_month.inject("") do |memo, month|
#      puts month.inspect
      memo += "<th colspan=\"#{month[1]}\">#{month[0].strftime('%b-%Y')}</th>"
    end
    
#    puts heading
    heading.html_safe
  end
  
  def day_heading
    heading = detail_columns.inject("") do |memo, date|
      memo += "<th colspan=\"#{date[1]}\">#{date[0].strftime('%d')}</th>"
    end
#    puts heading
    heading.html_safe
  end
  
  def detail_columns
    @routines_layout ||= @person.routines_layout
    @detail_columns ||= Hash[@routines_layout.each_with_object(Hash.new(0)) do |(date, crs), hash| 
      crs.each_with_object(hash) do |(date, crs), hash|
#        puts "date: #{date} crs: #{crs.count} crs #{crs.inspect}"
        hash[date] = [crs.count, hash[date]].max
      end
    end.sort]
  end
end
