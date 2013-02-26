class Lounge::DashboardController < ApplicationController
  def index
    # within search radius, has some of the likes and birth date is between
    # now - max_age.years and now - min_age.years
    @blah = User.near(current_user.address, current_user.user_profile.search_radius).
      where('user_profile.likes' => {'$in' =>  current_user.user_profile.likes}).and(
        'user_profile.birthday' => {'$gte' => (Date.today.beginning_of_year - current_user.user_profile.max_age.years)}).and(
        'user_profile.birthday' => {'$lte' => (Date.today - current_user.user_profile.min_age.years)}
      ).and('user_profile.gender' => current_user.user_profile.seeking).page params[:page].to_i

    @users = User.search_radius(current_user.address, current_user.user_profile.search_radius).
      with_likes(current_user.user_profile.likes).between_ages(current_user.user_profile.min_age,
        current_user.user_profile.max_age).with_gender(current_user.user_profile.seeking).page params[:page].to_i
  end

  def search
  end

end
