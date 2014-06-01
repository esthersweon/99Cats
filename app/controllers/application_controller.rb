class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user

  def login!(user)
    session[:token]=user.reset_session_token!
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_session_token(session[:token])
  end

  def logged_in?
    !!current_user
  end

  def logout
    current_user.try(:reset_session_token!)
    session[:token] = nil
  end

end
