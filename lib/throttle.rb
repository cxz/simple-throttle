require "throttle/version"
require "throttle/time_window/runner"

module Throttle

  HOUR_SECONDS = 3600
  DAYS_SECONDS = 24 * HOUR_SECONDS

  def self.per_hour(count)
    TimeWindow::Runner.new(HOUR_SECONDS, count)
  end

  def self.per_day(count)
    TimeWindow::Runner.new(DAYS_SECONDS, count)
  end
end

