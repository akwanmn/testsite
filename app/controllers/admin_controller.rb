class AdminController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  load_and_authorize_resource

  layout 'admin'
  #layout proc{|c| c.request.xhr? ? false : "admin" }

  # access denied messages
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

end