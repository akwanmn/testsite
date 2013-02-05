class Lounge::HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  def new
    @user = User.new
    @user.user_profile = UserProfile.new
    #@order = Order.new
    render 'index', layout: false
  end

  def signup
    # save user details first...then create order?
    # user = User.new(user_params)
    # user.user_profile = UserProfile.new(user_params[:user_profile_attributes])
    # user.save!
    # p card_params
    # o = Order.from_join_params(card_params)
    # o.user = user
    # o.name = user.full_name
    # p o.valid?
    # p o.errors
    # o.save!
    # p o.purchase
    #if user.save!

    #end
    # order = Order.from_join_params(user_params)
    # order.ip_address = request.env['REMOTE_ADDR']
    # if order.save
    #   if order.purchase
    #     result = 'TRUE'
    #   else
    #     Rails.logger.info order.inspect
    #     result = 'FALSE'
    #   end
    # end
    # render text: result
    # p order.valid?
    # p order.errsor
    # Rails.logger.info order.inspect
    render text: Rails.env == 'development' ? user_params.inspect : 'OK'
  end

  private
    # assign some parameters for a new signup
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
        user_profile_attributes: [
          :nickname,
          :address_street,
          :address_city,
          :address_state,
          :address_zip,
          :address_country,
          :first_name,
          :last_name
        ]
      )
    end

    def card_params
      params.require(:user).permit(
        user_profile_attributes: [
          :nickname,
          :address_street,
          :address_city,
          :address_state,
          :address_zip,
          :address_country,
          :first_name,
          :last_name
        ],
        orders: [
          :card_number,
          :card_verification,
          :card_expires_on
        ]
      )
    end
end
