require 'spec_helper'


module Throttle
  class DummyProxy
    attr_accessor :count
    attr_accessor :sleeps
    attr_accessor :log

    def initialize(interval_seconds, limit)
      @count = 0
      @sleeps = []
      @log = []
      @sleeper = ->(seconds) do
        @log << { action: :sleep, at: Time.now.to_i, amount: seconds }
        @sleeps << seconds
        Timecop.travel Time.now + seconds
      end
      @runner = TimeWindow::Runner.new(interval_seconds, limit, @sleeper)
    end

    def call(times)
      times.times.each do
        @runner.run do
          @count += 1
        end
        @log << { action: :run, at: Time.now.to_i }
      end
    end

  end
end
