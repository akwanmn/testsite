class Lounge::DashboardController < ApplicationController
  def index
    # within search radius, has some of the likes and birth date is between
    # now - max_age.years and now - min_age.years
    @users = User.near(current_user.address, current_user.user_profile.search_radius).
      where('user_profile.likes' => {'$in' =>  current_user.user_profile.likes}).and(
        'user_profile.birthday' => {'$gte' => (Date.today - current_user.user_profile.max_age.years)}).and(
        'user_profile.birthday' => {'$lte' => (Date.today - current_user.user_profile.min_age.years)}
      )
  end
end
