source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.12'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-fileupload-rails'
end
#gem 'asset_sync' # store assets on S3

gem 'chosen-rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'mongoid', '~> 3.0.0' # database
gem 'activemerchant', :require => 'active_merchant' # credit card processing
gem 'sendgrid' # email
gem 'aasm' # state machine
gem 'simple_form' # forms
gem 'carmen-rails'
gem 'devise' # authentication
gem 'cancan' # authorization
gem 'geocoder' # geo location
#gem 'sidekiq' # jobs platform
gem 'kaminari' # pagination
gem 'kaminari-bootstrap'
gem 'active_model_serializers', :github => 'rails-api/active_model_serializers'

#gem 'flipper' # turn on and off services for people (new features)

# image processing
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'fog'
gem 'mini_magick'

# security
gem 'strong_parameters'

# monitoring
gem 'newrelic_rpm'

# required by heroku
#gem 'thin'
gem 'unicorn'

group :development do
  gem 'powder'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'fabrication' # fixtures
  gem 'ffaker'
  gem 'foreman'
end

group :test do
  gem 'rspec-rails' # rspec / testing
  gem 'database_cleaner'
end