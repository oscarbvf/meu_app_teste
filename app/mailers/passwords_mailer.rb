class PasswordsMailer < Devise::Mailer
  default from: "no-reply@meuappteste.com"

  def reset_password_instructions(record, token, opts = {})
    @user = record
    @token = token
    @reset_url = edit_user_password_url(
      reset_password_token: token,
      host: default_url_options[:host]
    )

    mail(to: @user.email, subject: "Reset your password")
  end

  private

  def default_url_options
    # ajuste para o seu ambiente
    { host: "localhost", port: 3000 }
  end
end
