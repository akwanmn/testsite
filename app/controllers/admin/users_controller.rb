class Admin::UsersController < AdminController
  prepend_before_filter :find_deleted, only: [:restore]
  before_filter :find_user, only: [:edit, :update, :disable]

  def index
    if params[:deleted]
      @users = User.deleted.page params[:page]
    else
      @users = User.order_by('email ASC').page params[:page]
    end
  end

  def update
    respond_to do |format|
      if params[:user][:password].blank?
        result = @user.update_without_password(params[:user])
      else
        result = @user.update_with_password(params[:user])
      end
      if result
        format.html { redirect_to admin_users_path, notice: "#{@user.full_name} was successfully updated."}
      else
        format.html { flash[:error] = 'There were validation errors.'; render action: 'edit'} 
      end
    end
  end

  # we don't want to 'destroy' users so lets just disable them.
  def disable
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "#{@user.full_name} has been deleted." }
    end
  end

  def restore
    @user.restore
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "#{@user.full_name} has been restored."}
    end
  end

  def find_deleted
    @user = User.deleted.where(id: params[:id]).first
  end

  # Find  the user
  def find_user
    @user = User.find(params[:id])
  end
end
