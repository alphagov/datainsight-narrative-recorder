source "https://rubygems.org"

gem "rake"
gem "datainsight_logging", :git => "git@github.com:alphagov/datainsight_logging.git"
#gem "datainsight_logging", :path => "../datainsight_logging"

group :exposer do
  gem "sinatra"
  gem "unicorn"
end

group :recorder do
  gem "gli", "1.6.0"
  gem "bunny"
end

group :test do
  gem "rspec"
  gem "ci_reporter"
end
