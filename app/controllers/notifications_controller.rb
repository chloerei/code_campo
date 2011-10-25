class NotificationsController < ApplicationController
  before_filter :require_logined

  def index
    @notifications = current_user.notifications.order_by([[:created_at, :desc]]).page(params[:page])
  end
end
