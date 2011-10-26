class NotificationsController < ApplicationController
  before_filter :require_logined
  respond_to :html, :js, :only => [:destroy]

  def index
    @notifications = current_user.notifications.order_by([[:created_at, :desc]]).page(params[:page])
  end

  def destroy
    @notification = current_user.notifications.find params[:id]
    @notification.destroy
    respond_with(@notification) do |format|
      format.html { redirect_referrer_or_default notifications_path }
      format.js { render :destroy, :layout => false }
    end
  end
end
