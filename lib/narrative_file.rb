require "bundler"
Bundler.require

require 'json'

class NarrativeFile

  FILENAME = '/var/lib/datainsight-narrative-recorder.json'

  def initialize(filename = FILENAME)
    @filename = filename
  end

  def content
    read['payload']['content']
  end

  def read
    begin
      JSON.parse(File.read(@filename))
    rescue => e
      logger.warn { e }
      {'payload' => {'content' => ''}}
    end
  end

  def write json
    File.open(@filename, "w") { |f| f.write(json) }
  end
end
