require_relative '../narrative_file'

module Recorders
  class NarrativeRecorder

    def initialize
      client = Bunny.new ENV['AMQP']
      client.start
      @queue = client.queue(ENV['QUEUE'] || 'narrative')
      exchange = client.exchange('datainsight', :type => :topic)
      @queue.bind(exchange, :key => '*.narrative')
      logger.info { "Bound to *.narrative, listening for events" }
    end

    def run
      @queue.subscribe do |msg|
        begin
          logger.info { "Received message: #{msg[:payload]}" }
          NarrativeFile.new().write(msg[:payload])
        rescue Exception => e
          logger.error { e }
        end
      end
    end
  end
end
