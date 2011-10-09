class Settings::FavoriteTagsController < ApplicationController
  before_filter :require_logined
  layout 'settings'
  respond_to :html, :js, :only => [:destroy]

  def index
  end

  def create
    if current_user.update_attributes params[:user]
      flash[:success] = 'Successful Add Favorite Tags.'
      redirect_to :action => :index
    else
      render :index
    end
  end

  def destroy
    current_user.favorite_tags.delete params[:id]
    current_user.save
    respond_with do |format|
      format.html { redirect_to :action => :index }
      format.js { render :nothing => true }
    end
  end
end
