class Settings::AccountsController < ApplicationController
  before_filter :require_logined
  layout 'settings'

  def show
    logger.info current_user.inspect
  end

  def update
    if current_user.update_attributes params[:user]
      flash[:success] = 'Successful Update.'
      redirect_to :action => :show
    else
      render :show
    end
  end
end
