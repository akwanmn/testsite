class Lounge::HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  def new
    @user = User.new
    @user.user_profile = UserProfile.new
    render 'index', layout: false
  end

  def signup
    render text: Rails.env == 'development' ? params.inspect : 'OK'
  end
end
