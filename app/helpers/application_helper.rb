module ApplicationHelper
    # Checks safely for a logged user and Warden available
  def safe_user_signed_in?
    !!(defined?(warden) && warden && respond_to?(:user_signed_in?) && user_signed_in?)
  rescue
    false
  end

  # Checks safely for a logged user and Policy available
  def safe_policy?(record, action)
    safe_user_signed_in? && policy(record).public_send("#{action}?")
  rescue
    false
  end
end
