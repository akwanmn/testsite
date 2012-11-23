class Admin::UsersController < AdminController
  def index
    @users = User.page params[:page]
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if params[:user][:password].blank?
        Rails.logger.debug 'With Password..........................'
        result = @user.update_without_password(params[:user])
      else
        Rails.logger.debug 'With Password..........................'
        result = @user.update_with_password(params[:user])
      end
      if result
        format.html { redirect_to admin_users_path, notice: "User was successfully updated."}
      else
        format.html { flash[:error] = 'There were validation errors.'; render action: 'edit'} 
      end
    end
  end
end
