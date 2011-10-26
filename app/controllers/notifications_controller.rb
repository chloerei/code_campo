class NotificationsController < ApplicationController
  before_filter :require_logined
  respond_to :html, :js, :only => [:mark_all_as_read, :destroy]

  def index
    @notifications = current_user.notifications.order_by([[:created_at, :desc]]).page(params[:page]).cache
    current_user.read_notifications(@notifications)
  end

  def mark_all_as_read
    current_user.mark_all_notifications_as_read
    respond_with do |format|
      format.html { redirect_referrer_or_default notifications_path }
      format.js { render :layout => false }
    end
  end

  def destroy
    @notification = current_user.notifications.find params[:id]
    @notification.destroy
    respond_with(@notification) do |format|
      format.html { redirect_referrer_or_default notifications_path }
      format.js { render :layout => false }
    end
  end
end
