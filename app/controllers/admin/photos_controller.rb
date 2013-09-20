class Admin::PhotosController < ApplicationController
  #respond_to :js
  def index
    render text: params[:user_id]
  end

  def create
    @user = User.find(params[:user_id])
    @photo = @user.photos.new(params[:photos])
    @user.user_profile.update_attribute(:percent_complete, @user.user_profile.calculate_profile_percentage) if @photo.save!
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @photo = @user.photos.find(params[:id])
    pass = true
    respond_to do |format|
      if @photo.destroy
        format.js { render layout: false }
      end
    end
  end
end
