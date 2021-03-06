class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation.subject
  #
  def activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def welcome(user)
    @user = user
    mail to: user.email, subject: "Welcome!"
  end

  def account_info(user)
    @user = user
    mail to: user.email, subject: "Account information!"
  end
end
