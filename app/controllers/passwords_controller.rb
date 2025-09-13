class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.find_by(email: params[:email])
      token = user.generate_password_reset_token
      # - Jobs run immediately
      # - No queue persistence
      # - If the container restarts or crashes, any job that was "in progress" is lost
      # - For production, you would need something like SolidQueue or Sidekiq + Redis
      # - Good simulation of background behavior for tests
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to new_session_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private

    def set_user_by_token
      @user = User.find_by_password_reset_token(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired." unless @user
    end

    def user_params
      params.permit(:password, :password_confirmation)
    end
end
