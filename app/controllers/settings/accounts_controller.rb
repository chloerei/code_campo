class Settings::AccountsController < ApplicationController
  before_filter :require_logined

  def show
  end

  def update
    if current_user.update_attributes params[:user]
      flash[:success] = 'Successful Update.'
      redirect_to :action => :show
    else
      logger.info current_user.errors.inspect
      render :show
    end
  end
end
