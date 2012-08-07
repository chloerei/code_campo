class UsersController < ApplicationController
  before_filter :require_no_logined, :except => :destroy
  before_filter :require_logined, :only => :destroy

  def new
    @user = User.new
    store_location request.referrer if request.referrer.present?
  end

  def create
    @user = User.new params[:user]
    if @user.save
      login_as @user
      redirect_back_or_default root_url
    else
      render :new
    end
  end

  def destroy
    current_user.destroy
    flash[:success] = I18n.t('settings.accounts.show.delete_success', :name => current_user.name)
    logout
    redirect_back_or_default root_url
  end
end
