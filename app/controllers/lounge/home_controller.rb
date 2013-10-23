class Lounge::HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :build_signup_form, only: [:new, :login]

  def landing
    render 'landing', layout: false
  end

  def new
    render 'index', layout: false
  end

  def signup
    @user   = User.new(user_params)
    # create profile
    @user.user_profile = UserProfile.new(user_params[:user_profile_attributes])
    # create order
    @order  = Order.new
    card_params[:request_ip] = request.env['REMOTE_ADDR']
    @order.amount = Order::DEFAULT_PRICE # hard coded for now.
    @order.from_join_params(card_params)

    respond_to do |format|
      # force validations....
      @user.valid?
      @order.valid?
      if @user.valid? && @order.valid?
        # if its true then save the items.
        if @order.join_purchase
          @user.save
          @order.user = @user
          @order.finalize_transaction
          sign_in @user, bypass: true
          redirect_to [:match_criteria, :lounge, :profile, :index] and return
        else
          format.html { flash[:error] = "#{@order.purchase_response.message}"; render 'index', layout: false }
          # failed transaction
          @order.finalize_transaction('decline')
        end
      else
        puts "*" * 20
        # bad validations
        format.html { render 'index', layout: false}
      end
    end
  end

  private
    def build_signup_form
      @user = User.new
      @user.user_profile = UserProfile.new
      @order = Order.new
    end

    # assign some parameters for a new signup
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :nickname,
        :accepted_terms,
        user_profile_attributes: [
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
          :address_street,
          :address_city,
          :address_state,
          :address_zip,
          :address_country,
          :first_name,
          :last_name
        ],
        order: [
          :card_number,
          :card_verification,
          :card_expires_on
        ]
      )
    end
end
