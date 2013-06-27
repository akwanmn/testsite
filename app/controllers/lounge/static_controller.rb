class Lounge::StaticController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'layouts/static'

  def faq
  end

  def terms
  end

  def tips
  end

  def articles
  end

  def success
  end

  def privacy
  end
  def story; end



  # articles stuff
  def write_your_profile; end
  def intimacy; end
  def safety; end
  def fraudster; end
end
