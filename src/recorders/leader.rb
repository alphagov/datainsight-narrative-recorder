require 'bundler/setup'
Bundler.require

require 'bunny'

module Recorders
  class LeaderRecorder

    def initialize
      client = Bunny.new ENV['AMQP']
      client.start
      @queue = client.queue(ENV['QUEUE'] || 'leader') 
      exchange = client.exchange('datainsight', :type => :topic)
      @queue.bind(exchange, :key => '*.leader')
    end

    def run
      @queue.subscribe do |msg|
        File.open('leader.json', 'w') do |handle|
          handle.puts msg[:payload]
        end
      end
    end
  end
end
