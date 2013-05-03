class Lounge::PhotosController < ApplicationController
  before_filter :find_user

  # def index
  #   render text: params[:user_id]
  # end

  def create
    @photo = @user.photos.new(params[:photos])
    respond_to do |format|
      if @photo.save!
        # do this to just update their profile percentage.
        @user.user_profile.update_attribute(:percent_complete, @user.user_profile.calculate_profile_percentage)
      end
      format.js { render layout: false }
    end
  end

  def destroy
    @photo = @user.photos.find(params[:id])
    pass = true
    respond_to do |format|
      if @photo.destroy
        @user.user_profile.update_attribute(:percent_complete, @user.user_profile.calculate_profile_percentage)
        format.js { render layout: false }
      end
    end
  end

  def find_user
    @user = current_user
  end
end
