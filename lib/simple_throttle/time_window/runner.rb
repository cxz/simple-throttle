module SimpleThrottle
  module TimeWindow
    ##
    # Executes at most a number of times within given time window.
    #
    class Runner
      # Parameters:
      # +wait_s+: minimum number os seconds between +count+ block invocations
      # +count+: maximum number of times block may be called between +wait_s+ seconds
      def initialize(wait_s, count, sleep = ->(seconds) { sleep seconds })
        @max = count
        @last = 0.0 #last invocation timestamp
        @count = 0
        @wait_s = wait_s.to_f
        @sleep = sleep
      end

      # Run given +block+ either immediately (if allowed) or after sleep.
      def run(&block)
        #puts "count: #{@count}, delta: #{Time.now.to_f - @last}"

        restart_window_if_needed

        if !within_limit?
          sleep_interval = @wait_s - delta
          #puts "simple_throttle forced sleep for #{sleep_interval}"
          @sleep.call sleep_interval
        end

        @count += 1
        #puts "running "
        yield
      end

      def within_limit?
        restart_window_if_needed
        @count < @max
      end

      def delta
        now = Time.now.to_f
        now - @last
      end

      def restart_window_if_needed
        if delta >= @wait_s
          #puts "resetting"
          @last = Time.now.to_f
          @count = 0
        end
      end

    end
  end
end
