module SimpleThrottle
  module Manual
    class Runner
      #client can manually override the remaining count.
      attr_accessor :remaining

      # Parameters:
      # +wait_s+: minimum number os seconds between +count+ block invocations
      # +count+: maximum number of times block may be called between +wait_s+ seconds
      def initialize(wait_s, count, sleep = ->(seconds) { sleep seconds })
        @max = count
        @remaining = @max
        @wait_s = wait_s.to_f
        @sleep = sleep
      end

      # Run given +block+ either immediately (if allowed) or after sleep.
      def run(&block)
        if @remaining < 1
          @sleep.call @wait_s
          @remaining = @max
        end

        @remaining -= 1
        yield
      end

      def within_limit?
        @remaining > 0
      end
    end
  end
end
