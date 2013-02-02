class Lounge::HomeController < ApplicationController
  def index
    render 'results', layout: false
  end
end
