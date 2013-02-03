class Lounge::HomeController < ApplicationController
  def index
    render 'profile', layout: false
  end
end
