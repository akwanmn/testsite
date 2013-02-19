class Lounge::SessionsController < Devise::SessionsController
  def new
    @user = User.new
    @user.user_profile = UserProfile.new
    @order = Order.new
    render 'lounge/home/index', layout: false
  end
end