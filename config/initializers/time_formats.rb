=begin rdoc
Output the date in a compact format that shows the day and time.
=end
Time::DATE_FORMATS[:humanized_ago]  = ->(time) do
  st = Time.now.beginning_of_day
  nd = Time.now.end_of_day
  
  case 
  when time.between?(st + 1.day, nd + 1.day)
    "Tomorrow #{time.strftime('%H:%M')}"
  when time.between?(st, nd)
    "Today #{time.strftime('%H:%M')}"
  when time.between?(st - 1.day, nd - 1.day)
    "Yesterday #{time.strftime('%H:%M')}"
  when time.between?(st - 6.day, nd - 2.day)
    time.strftime('%a %H:%M')
  else 
    time.strftime('%y-%b-%d %H:%M')
  end
end
Time::DATE_FORMATS[:datetime_local]  = "%Y-%m-%d %H:%M:%S"

