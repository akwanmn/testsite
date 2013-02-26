class Lounge::DashboardController < ApplicationController
  def index
    @users = User.search_radius(current_user.address, current_user.user_profile.search_radius).
      with_likes(current_user.user_profile.likes).
      between_ages(current_user.user_profile.min_age, current_user.user_profile.max_age).
      with_gender(current_user.user_profile.seeking).page params[:page].to_i
  end

  def search
    @users = User.search_radius(current_user.address, current_user.user_profile.search_radius).
      with_likes(current_user.user_profile.likes).
      between_ages(current_user.user_profile.min_age, current_user.user_profile.max_age).
      with_gender(current_user.user_profile.seeking).page params[:page].to_i
    render 'lounge/dashboard/index'
  end

end
