class Lounge::PasswordResetsController < ApplicationController
  skip_before_filter :authenticate_user!
  def new
    render :new, layout: false
  end
end
