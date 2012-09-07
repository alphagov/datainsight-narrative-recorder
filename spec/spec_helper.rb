require 'bundler/setup'
Bundler.require(:default, :test, :recorder)

require "tempfile"

require_relative '../lib/app'
require_relative '../lib/recorders/narrative'
