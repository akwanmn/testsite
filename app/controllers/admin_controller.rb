class AdminController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_user!

  layout 'admin'

  # protected

  # def layout_by_resource
  #   if devise_controller?
  #     "layout_name_for_devise"
  #   else
  #     "application"
  #   end
  # end
end