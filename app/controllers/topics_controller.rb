class TopicsController < ApplicationController
  before_filter :require_logined, :except => [:index, :show]

  def index
    @topics = Topic.order_by([[:actived_at, :desc]]).page(params[:page]).per(15)
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = current_user.topics.new params[:topic]
    if @topic.save
      redirect_to @topic
    else
      render :new
    end
  end

  def show
    @topic = Topic.find params[:id]
  end
end
