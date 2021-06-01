# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
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
require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = Rails.env.to_sym
set :environment, rails_env
set :output, 'log/cron.log'

every 1.days, at: '11:00 am' do
  begin
    runner "ReservRemindMailJob.perform_later"
  rescue => e
    Rails.logger.error("aborted rails runner")
    raise e
  end
end

every 1.days, at: '11:00 am' do
  begin
    runner "EventRemindMailJob.perform_later"
  rescue => e
    Rails.logger.error("aborted rails runner")
    raise e
  end
end

every 1.days, at: '00:00 am' do
  begin
    runner "Schedule.end_events_of_the_day"
  rescue => e
    Rails.logger.error("aborted rails runner")
    raise e
  end
end
