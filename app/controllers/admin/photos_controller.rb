class Admin::PhotosController < ApplicationController
  #respond_to :js
  def index
    render text: params[:user_id]
  end

  def create
    user = User.find(params[:user_id])
    @photo = user.photos.new(params[:photos])
    respond_to do |format|
      @photo.save!
      format.js { render layout: false }
    end
  end

  def destroy
    user = User.find(params[:user_id])
    @photo = user.photos.find(params[:id])
    Rails.logger.debug @photo.inspect
  end
end
