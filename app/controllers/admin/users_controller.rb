class Admin::UsersController < AdminController
  prepend_before_filter :find_suspended, only: [:restore]
  before_filter :find_user, only: [:edit, :update, :disable, :edit_profile, :extended_profile]
  load_and_authorize_resource

  def index
    if params[:deleted]
      @users = User.suspended.page params[:page].to_i
    else
      @users = User.search(params[:search]).order_by('email ASC').page params[:page].to_i
    end
  end

  def new
    @user = User.new
  end

  def update
    respond_to do |format|
      if params[:user][:password].blank?
        result = @user.update_without_password(user_params)
      else
        result = @user.update_attributes!(user_params)
      end
      if result
        format.html { redirect_to edit_admin_user_path(@user), notice: "#{@user.full_name} was successfully updated."}
      else
        format.html { flash[:error] = 'There were validation errors.'; render action: 'edit'}
      end
    end
  end

  def edit_profile
  end

  def update_profile
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.user_profile.update_attributes(params[:user][:user_profile_attributes])
        format.html { redirect_to edit_profile_admin_user_path(@user), notice: 'Profile has been updated.'}
      else
        format.html { flash[:error] = 'There were validation errors.'; render action: 'edit_profile' }
      end
    end
  end


  # we don't want to 'destroy' users so lets just disable them.
  def disable
    @user.suspend!
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "#{@user.full_name} has been deleted." }
    end
  end

  def restore
    @user.restore!
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "#{@user.full_name} has been restored."}
    end
  end

  def find_suspended
    @user = User.suspended.where(id: params[:id]).first
  end

  # Find  the user
  def find_user
    @user = User.find(params[:id])
  end

  private
    # assign some parameters for admin atm, this way we can protect what we want
    # for different roles as we go forward.
    def user_params
      if current_user.is_admin
        params.require(:user).permit(:email, :is_admin, :password, :password_confirmation, :nickname,
          user_profile_attributes: [
          :birthday, :first_name, :last_name, :address_zip, :address_country,
          :address_city, :address_state, :gender, :seeking, :min_age, :max_age,
          :address_street, :biography, :occupation, :education, :ethnicity, :religion,
          :search_radius, :timezone, :nickname, :distance_type, :marital_status, :health_fitness, :children, :receive_emails,
      :drinking, :smoking, :eating, :politics, :reading, :travel, :career, {:nightlife => []}, {:outdoor_activities => []}, {:likes => []}
        ])
      else
        params.require(:user).permit(:email, user_profile_attributes: [
          :birthday, :first_name, :last_name, :address_zip, :address_country,
          :address_city, :address_state, :gender, :seeking, :min_age, :max_age,
          :address_street, :biography, :occupation, :education, :ethnicity, :religion,
          :search_radius, :timezone, :marital_status, :health_fitness, :children, :receive_emails,
      :drinking, :smoking, :eating, :politics, :reading, :travel, :career, {:nightlife => []}, {:outdoor_activities => []}, {:likes => []}
        ])
      end
    end
end
