class Lounge::DashboardController < ApplicationController
  before_filter :set_default_values, :do_search, only: [:index, :search]
  load_and_authorize_resource :user

  def search
    render 'lounge/dashboard/index'
  end

  #########
  # Private
  #########

  def do_search
    if current_user.coordinates.nil?
      @users = User.with_likes(@likes).between_ages(@min_age, @max_age).
        with_gender(@seeking).not_current_user(current_user).sort_option(@sort_by).page params[:page].to_i
    else
      @users = User.search_radius(current_user.address, current_user.user_profile.search_radius, current_user.user_profile.distance_type).
        with_likes(@likes).between_ages(@min_age, @max_age).
        with_gender(@seeking).not_current_user(current_user).sort_option(@sort_by).page params[:page].to_i
    end
  end
  private :do_search

  # params that we allow
  def search_params
    params.permit(:looking_for, :utf8, :authenticity_token, :min_age,
      :max_age, :sort_by, likes:[])
  end
  private :search_params

  # set some values if params are set, otherwise defaults.
  def set_default_values
    # set some defaults just in case.
    @likes     = params[:likes] || current_user.user_profile.likes
    @min_age   = params[:min_age] || current_user.user_profile.min_age
    @max_age   = params[:max_age] || current_user.user_profile.max_age
    @seeking   = params[:looking_for].present? ? params[:looking_for] : current_user.user_profile.seeking
    @sort_by   = params[:sort_by] || 'joined'
    @sort_options = [
      {id: 'joined', name: 'Recently Joined'},
      {id: 'updated', name: 'Recently Updated'}
    ]
  end
  private :set_default_values
end
