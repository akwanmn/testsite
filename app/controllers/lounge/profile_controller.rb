class Lounge::ProfileController < ApplicationController
  before_filter :set_current_user
  load_and_authorize_resource :user, parent: true

  def match_criteria
    @profile = @user.user_profile
    puts "*" * 50
    p @profile
  end

  def update_match_criteria
    @profile = @user.user_profile
    @profile.skip_validation = true
    @profile.likes = params[:likes]
    @profile.attributes = params[:user_profile]
    @profile.save!
    redirect_to lounge_dashboard_index_path
  end

  def myaccount
    @user.user_profile.skip_validation = true
    if params[:user][:password].blank?
      result = @user.update_without_password(user_params)
    else
      result = @user.update_attributes(user_params)
    end
    respond_to do |format|
      if result
        format.html { redirect_to modify_lounge_profile_index_path(anchor: 'account'), notice: "Account successfully updated." }
      else
        format.html { flash[:error] = 'There were validation errors.'; redirect_to modify_lounge_profile_index_path(anchor: 'account')}
      end
    end
  end

  # updates details about you.
  def update
    result = @user.update_without_password(user_params)
    respond_to do |format|
      if result
        step_2 = params[:user][:user_profile_attributes].has_key?(:likes) # true/false
        format.html { redirect_to (step_2 ? modify_lounge_profile_index_path(anchor: 'photos') : advanced_details_lounge_profile_index_path) }
      else
        format.html { flash[:error] = 'There were validation errors'; render action: :edit }
      end
    end
  end

  def disable
    @user.suspend!
    respond_to do |format|
      format.html { flash[:alert] = "#{@user.full_name} your account has been cancelled."; redirect_to root_path }
    end
  end

  def photos
    @hash_tag = 'photos'
    render action: :edit
  end

  def show
    @message = Message.new
    @user = User.where(nickname: params[:id].to_s).first
    @random_image = @user.random_profile_image
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
      :search_radius, :distance_type, :timezone, :marital_status, :health_fitness, :children, :receive_emails,
      :drinking, :smoking, :eating, :politics, :reading, :travel, :career, {:nightlife => []}, {:outdoor_activities => []}, {:likes => []}
    ])
  end
end
