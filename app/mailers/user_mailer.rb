class UserMailer < ApplicationMailer
  default from: "gameofzones@gmail.com"

  def forgot_password_email(user)
    @reset_code = SecureRandom.hex(8)
    user.password_reset_code = @reset_code
    user.save!

    @user = user

    mail(subject: "Password Reset - Game of Zones", to: user.email)
  end
end
