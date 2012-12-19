class Admin::PhotosController < ApplicationController

  def index
    render text: params[:user_id]
  end

  def create
    user = User.find(params[:user_id])
    Rails.logger.debug "*" * 100
    Rails.logger.debug user
    @photo = user.photos.new(params[:photo])
    Rails.logger.debug @photo.inspect
    respond_to do |format|
      if @photo.save!
        Rails.logger.debug "SAVED!"
        format.json { render json: @photo.to_json, status: :created }
      else
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end
end
