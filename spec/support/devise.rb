RSpec.configure do |config|
  # authorization helpers
  config.include Devise::TestHelpers, :type => :controller
end