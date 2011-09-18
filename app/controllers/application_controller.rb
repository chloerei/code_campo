class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logined?, :current_user

  protected

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
end
