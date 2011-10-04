class Settings::ProfilesController < ApplicationController
  before_filter :require_logined
  layout 'settings'

  def show
  end

  def update
    if current_user.profile.update_attributes params[:profile]
      flash[:success] = 'Successful Update.'
      redirect_to :action => :show
    else
      render :show
    end
  end
end
