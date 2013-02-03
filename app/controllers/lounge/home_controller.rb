class Lounge::HomeController < ApplicationController
  def new
    @user = User.new
    @user.user_profile = UserProfile.new
    render 'index', layout: false
  end

  def signup
    render text: params.inspect
  end
end
