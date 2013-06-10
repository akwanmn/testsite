class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  layout :layout_by_resource

  # access denied messages
  rescue_from CanCan::AccessDenied do |exception|
    #Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to root_url, :alert => exception.message
  end

  protected

  # in case we ever need  to have a different layout. like
  # in the dashboard :)
  def layout_by_resource
    "layouts/application"
  end

  def stored_location_for(resource_or_scope)
    nil
  end
  private :stored_location_for

  def after_sign_in_path_for(resource_or_scope)
    if current_user.is_admin
      admin_path
    else
      #if current_user.user_profile.nil? || current_user.user_profile.percent_complete.to_i < 50
      #  modify_lounge_profile_index_path
      #else
      lounge_dashboard_index_path
      #end
    end
  end
  private :after_sign_in_path_for

end
