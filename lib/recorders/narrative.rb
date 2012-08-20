require 'bundler/setup'
Bundler.require

require 'bunny'

module Recorders
  class NarrativeRecorder

    def initialize(logger)
      @logger = logger
      client = Bunny.new ENV['AMQP']
      client.start
      @queue = client.queue(ENV['QUEUE'] || 'narrative')
      exchange = client.exchange('datainsight', :type => :topic)
      @queue.bind(exchange, :key => '*.narrative')
      @logger.info("Bound to *.narrative, listening for events")
    end

    def run
      @queue.subscribe do |msg|
        begin
          @logger.info("Received message: #{msg[:payload]}")
          File.open('narrative.json', 'w') do |handle|
            handle.puts msg[:payload]
          end
        rescue Exception => e
          @logger.error("#{e} \n" + e.backtrace.join("\n"))
        end
      end
    end
  end
end
