class Lounge::StaticController < ApplicationController
  skip_before_filter :authenticate_user!

  def faq
    render text: 'FAQ'
  end

  def terms
    render text: 'Terms'
  end

  def tips
    render text: 'Tips'
  end

  def articles
    render text: 'Articles'
  end

  def success
    render text: 'Success'
  end

  def privacy
    render text: 'Privacy'
  end
end
