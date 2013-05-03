class Notifier < ActionMailer::Base
  default from: "support@2date4love.com"

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to 2date4love.com')
  end
end
