require 'spec_helper'

require_relative '../dummy_proxy'

module Throttle::TimeWindow
  describe Runner do

    before do
      Timecop.freeze(Time.now)
      @t_0 = Time.now.to_i
    end

    after do
      Timecop.return
    end

    let(:interval_seconds) { 5.0 }
    let(:limit) { 1 }

    context 'when number of executions is under the limit' do
      let(:executions) { limit }

      it 'does not sleep' do
        runner = Throttle::DummyProxy.new(interval_seconds, limit)
        runner.call(executions)

        expect(runner.count).to eq(executions)
        expect(runner.sleeps).to be_empty
      end
    end

    context 'when limit is reached' do
      let(:executions) { 2 }

      it 'sleeps' do

        runner = Throttle::DummyProxy.new(interval_seconds, limit)
        runner.call(executions)

        expect(runner.count).to eq(executions)
        expect(runner.sleeps).to eq([interval_seconds])

        expect(runner.log).to eq([
          {action: :run,   at: @t_0},
          {action: :sleep, at: @t_0, amount: interval_seconds},
          {action: :run,   at: @t_0 + interval_seconds}
        ])
      end

    end


  end
end