class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  #  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  #  allow_browser versions: :modern

  #  helper_method :current_user

  #  before_action :set_current_session

  # def current_user
  #  Current.session&.user
  # end

  # private

  # Session management is handled via a persistent model and a signed cookie.
  # We no longer rely on `session[:user_id]`; instead, the session ID is stored in
  # `cookies.signed[:session_id]` and associated with a database-backed session record.
  # def set_current_session
  #  if cookies.signed[:session_id]
  #    Current.session ||= Session.find_by(id: cookies.signed[:session_id])
  #  end
  # end
end
