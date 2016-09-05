require "simple_throttle/version"
require "simple_throttle/time_window/runner"
require "simple_throttle/manual/runner"

module SimpleThrottle

  HOUR_SECONDS = 3600
  DAYS_SECONDS = 24 * HOUR_SECONDS

  def self.per_hour(count)
    TimeWindow::Runner.new(HOUR_SECONDS, count.to_i)
  end

  def self.per_day(count)
    TimeWindow::Runner.new(DAYS_SECONDS, count.to_i)
  end

  def self.hourly_manual(count)
    Manual::Runner.new(HOUR_SECONDS, count.to_i)
  end
end

