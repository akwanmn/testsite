class AdminController < ActionController::Base
  protect_from_forgery
  before_filter :verify_is_admin
  load_and_authorize_resource

  layout 'admin'

  # access denied messages
  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to root_url, :alert => exception.message
  # end

  def verify_is_admin
    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.is_admin)
  end

end