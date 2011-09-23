class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logined?, :current_user

  protected

  def require_logined
    unless logined?
      store_location
      redirect_to login_url
    end
  end

  def current_user
    @current_user ||= login_from_session unless defined?(@current_user)
    @current_user
  end

  def logined?
    !!current_user
  end

  def login_as(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
  end

  def login_from_session
    if session[:user_id].present?
      begin
        User.find session[:user_id]
      rescue
        session[:user_id] = nil
      end
    end
  end

  def store_location(path = nil)
    session[:return_to] ||= path || request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
