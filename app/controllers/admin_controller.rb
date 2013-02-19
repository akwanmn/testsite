class AdminController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :verify_is_admin
  load_and_authorize_resource

  layout 'admin'

  # access denied messages
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  # make sure the person accessing this area is not only authorized but is also an admin.
  def verify_is_admin
    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.is_admin)
  end

end