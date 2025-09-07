class ApplicationController < ActionController::Base
  include Pundit::Authorization


  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private

  def user_not_authorized
    flash.now[:alert] = "Operation not allowed."
    redirect_to(request.referrer || root_path)
  end
end
