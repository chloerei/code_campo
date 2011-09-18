class TopicsController < ApplicationController
  before_filter :require_logined, :except => [:index]

  def index
    @topics = Topic.order_by([[:actived_at, :desc]]).page(params[:page]).per(15)
  end

  def new
    @topic = Topic.new
  end
end
