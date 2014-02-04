# Use this file to easily define all of your cron jobs.
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every :day, at: '12:30 am', roles: [:db] do
  rake "db:backup", output: 'log/backup.log' #{:error => 'error.log', :standard => 'cron.log'}
end

