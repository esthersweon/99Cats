class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user

  def login!(user)
    session[:token] = user.reset_session_token!
  end

  def current_user
    return nil unless session[:token]
    @current_user ||= User.find_by_session_token(session[:token])
  end

  def logged_in?
    !!current_user
  end

  def logout
    current_user.try(:reset_session_token!)
    session[:token] = nil
  end

  def require_user!
    redirect_to new_session_url if current_user.nil?
  end
end
