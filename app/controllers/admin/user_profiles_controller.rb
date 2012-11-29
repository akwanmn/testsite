class Admin::UserProfilesController < AdminController
  def edit
    @user = User.find(params[:user_id])
    @user_profile = @user.user_profile
  end

  def update
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @user.update_attributes(params[:user_profile])
      else
        format.html { render action: 'edit'}
      end
    end
  end
end
