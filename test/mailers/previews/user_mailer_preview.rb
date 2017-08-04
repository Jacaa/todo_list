# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/activation
  def activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.activation(user)
  end

end
