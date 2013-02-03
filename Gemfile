source 'https://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.11'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-fileupload-rails'
end



gem 'chosen-rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'mongoid', '~> 3.0.0' # database
gem 'activemerchant', :require => 'active_merchant' # credit card processing
gem 'sendgrid' # email
gem 'aasm' # state machine
gem 'simple_form' # forms
gem 'country_select'
gem 'devise' # authentication
gem 'cancan' # authorization
gem 'geocoder' # geo location
#gem 'sidekiq' # jobs platform
#gem 'switch_user' # switch from admin to user
gem 'kaminari' # pagination
gem 'kaminari-bootstrap'
gem 'active_model_serializers', :github => 'rails-api/active_model_serializers'

# image processing
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'fog'
gem 'mini_magick'
gem 'strong_parameters'
gem 'newrelic_rpm'

#gem 'asset_sync' # store assets on S3

gem 'thin'
gem 'fabrication' # fixtures
gem 'ffaker'

group :development do
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :test do
  gem 'rspec-rails' # rspec / testing
  gem 'database_cleaner'
end

gem 'hpricot'
gem 'haml'
gem 'ruby_parser'