class TopicsController < ApplicationController
  before_filter :require_logined, :except => [:index, :show]
  before_filter :find_topic, :only => [:show]
  before_filter :find_user_topic, :only => [:edit, :update]

  def index
    @topics = Topic.active.page(params[:page])
  end

  def my
    @topics = current_user.topics.active.page(params[:page])
    render :index
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
    @reply = current_user.replies.new :topic => @topic if logined?
    @replies = @topic.replies.page(params[:page])
  end

  def edit
  end

  def update
    if @topic.update_attributes params[:topic]
      redirect_to @topic
    else
      render :edit
    end
  end

  protected
  
  def find_topic
    @topic = Topic.number(params[:id])
  end

  def find_user_topic
    @topic = current_user.topics.number(params[:id])
  end
end
