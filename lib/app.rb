require "bundler"
Bundler.require

require 'sinatra'

require_relative 'narrative'

get '/narrative' do
  content_type :json
  {:content => Narrative.new.content}.to_json
end
