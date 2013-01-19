class ApiController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  layout nil
end