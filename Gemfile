source 'https://rubygems.org'

gem 'rails', '3.2.9'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

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
gem 'sidekiq' # jobs platform
gem 'switch_user' # switch from admin to user
gem 'kaminari' # pagination
gem 'kaminari-bootstrap'

# image processing
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mini_magick'

group :development do
  gem 'foreman'
  gem 'thin'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'terminal-notifier-guard'
  gem 'quiet_assets'
  gem 'localtunnel'
end

group :test do
  gem 'fabrication' # fixtures
  gem 'rspec-rails' # rspec / testing
  gem 'database_cleaner'
  gem 'ffaker'
end

gem 'hpricot'
gem 'haml'
gem 'ruby_parser'