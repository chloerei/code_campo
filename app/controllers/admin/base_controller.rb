class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :require_logined, :require_admin

  protected

  def require_admin
    unless current_user.admin?
      redirect_to root_url
    end
  end
end
