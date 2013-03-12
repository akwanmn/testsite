class Lounge::DashboardController < ApplicationController
  before_filter :set_default_values
  def index
    @users = User.search_radius(current_user.address, current_user.user_profile.search_radius).
      with_likes(@likes).between_ages(@min_age, @max_age).
      with_gender(@seeking).not_current_user(current_user).page params[:page].to_i
  end

  def search
    Rails.logger.debug "*" * 100
    Rails.logger.debug search_params
    Rails.logger.debug "*" * 100
    @users = User.search_radius(current_user.address, current_user.user_profile.search_radius).
      with_likes(@likes).between_ages(@min_age, @max_age).
      with_gender(@seeking).not_current_user(current_user).page params[:page].to_i
    render 'lounge/dashboard/index'
  end

  # params that we allow
  def search_params
    params.permit(:looking_for, :utf8, :authenticity_token, :min_age,
      :max_age, likes:[])
  end
  private :search_params

  # set some values if params are set, otherwise defaults.
  def set_default_values
    # set some defaults just in case.
    @likes     = params[:likes] || current_user.user_profile.likes
    @min_age   = params[:min_age] || current_user.user_profile.min_age
    @max_age   = params[:max_age] || current_user.user_profile.max_age
    @seeking   = params[:looking_for].present? ? params[:looking_for] : current_user.user_profile.seeking
  end

end
