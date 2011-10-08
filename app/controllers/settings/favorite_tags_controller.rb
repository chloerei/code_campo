class Settings::FavoriteTagsController < ApplicationController
  before_filter :require_logined
  layout 'settings'

  def show
  end

  def update
    if current_user.update_attributes params[:user]
      flash[:success] = 'Successful Add Favorite Tags.'
      redirect_to :action => :show
    else
      render :index
    end
  end
end
