class Settings::PasswordsController < ApplicationController
  before_filter :require_logined
  layout 'settings'

  def show
  end

  def update
    if current_user.update_attributes params[:user]
      flash[:success] = I18n.t(:success_update)
      redirect_to :action => :show
    else
      render :show
    end
  end
end
