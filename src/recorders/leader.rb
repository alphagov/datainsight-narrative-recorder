require 'bundler/setup'
Bundler.require

require 'bunny'

module Recorders
  class LeaderRecorder

    def initialize(logger)
      @logger = logger
      client = Bunny.new ENV['AMQP']
      client.start
      @queue = client.queue(ENV['QUEUE'] || 'leader') 
      exchange = client.exchange('datainsight', :type => :topic)
      @queue.bind(exchange, :key => '*.leader')
      @logger.info("Bound to *.leader, listening for events")
    end

    def run
      @queue.subscribe do |msg|
        @logger.info("Received message: #{msg[:payload]}")
        File.open('leader.json', 'w') do |handle|
          handle.puts msg[:payload]
        end
      end
    end
  end
end
