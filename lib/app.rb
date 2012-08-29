require "bundler/setup"
Bundler.require(:default, :exposer)

require_relative 'narrative'

helpers Datainsight::Logging::Helpers

configure do
  enable :logging
  unless test?
    Datainsight::Logging.configure(:type => :exposer)
  end
end

get '/narrative' do
  content_type :json
  {:content => Narrative.new.content}.to_json
end

error do
  logger.error env['sinatra.error']
end
