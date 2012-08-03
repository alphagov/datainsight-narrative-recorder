require "bundler"
Bundler.require

require 'json'

class Narrative
  attr_accessor :content
  def initialize(filename = "narrative.json")
    File.open(filename, 'r') do |handle|
      payload = JSON.parse(handle.gets)['payload']
      @content = payload['content']
    end
  end
end
