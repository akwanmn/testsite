source 'https://rubygems.org'

gem 'rails', '3.2.9'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'haml-rails'
gem 'jquery-rails'

gem 'mongoid', '~> 3.0.0' # database
gem 'activemerchant', :require => 'active_merchant' # credit card processing
gem 'sendgrid' # email 
gem 'aasm' # state machine
gem 'simple_form' # forms
gem 'devise' # authentication
gem 'cancan' # authorization
gem 'geocoder' # geo location
gem 'sidekiq'

group :development do
  gem 'foreman'
  gem 'thin'
  gem 'guard-rspec'
  gem 'rb-fsevent'
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