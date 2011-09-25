class TopicsController < ApplicationController
  before_filter :require_logined, :except => [:index, :show]
  before_filter :find_topic, :only => [:show]
  before_filter :find_user_topic, :only => [:edit, :update]
  before_filter :raise_if_no_found, :only => [:show, :edit, :update]

  def index
    @topics = Topic.order_by([[:actived_at, :desc]]).page(params[:page])
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
    @topic = Topic.number(params[:id]).first
  end

  def find_user_topic
    @topic = current_user.topics.number(params[:id]).first
  end

  def raise_if_no_found
    raise Mongoid::Errors::DocumentNotFound.new(Topic, params[:id]) if @topic.nil?
  end
end
