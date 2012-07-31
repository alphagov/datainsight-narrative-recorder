require "bundler"
Bundler.require

require 'sinatra'

require_relative 'leader'

get '/leader' do
  content_type :json
  {:content => Leader.new.content}.to_json
end
