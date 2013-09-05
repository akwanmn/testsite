class Lounge::ProfileController < ApplicationController
  include Wicked::Wizard

  before_filter :set_current_user
  load_and_authorize_resource :user, parent: true

  steps :basic_details, :advanced_details

  def edit
    render_wizard
  end

  def advanced
    @user.update_attributes(user_params)
    render_wizard @user
  end

  # def myaccount
  #   render text: 'My Account Page'
  # end

  def update
    respond_to do |format|
      if params[:user][:password].blank?
        result = @user.update_without_password(user_params)
      else
        result = @user.update_attributes!(user_params)
      end
      if result
        format.html { redirect_to modify_lounge_profile_index_path, notice: "#{@user.full_name} was successfully updated."}
      else
        format.html { flash[:error] = 'There were validation errors.'; render action: 'edit'}
      end
    end
  end

  def show
    Rails.logger.debug "*" * 100
    Rails.logger.debug params.inspect
    @message = Message.new
    @user = User.where(nickname: params[:id].to_s).first
  end

  def set_current_user
    @user = current_user
  end
  private :set_current_user

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, user_profile_attributes: [
      :birthday, :first_name, :last_name, :address_zip, :address_country,
      :address_city, :address_state, :gender, :seeking, :min_age, :max_age,
      :address_street, :biography, :occupation, :education, :ethnicity, :religion,
      :search_radius, :distance_type, :timezone, {:likes => []}
    ])
  end
end
