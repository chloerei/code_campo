class TopicsController < ApplicationController
  before_filter :require_logined, :except => [:index, :show, :tagged]
  before_filter :find_topic, :only => [:show, :mark, :unmark]
  before_filter :find_user_topic, :only => [:edit, :update]

  def index
    @topics = Topic.active.page(params[:page])
  end

  def my
    @topics = current_user.topics.active.page(params[:page])
    render :index
  end

  def marked
    @topics = Topic.mark_by(current_user).active.page(params[:page])
    render :index
  end

  def replied
    @topics = Topic.reply_by(current_user).active.page(params[:page])
    render :index
  end

  def tagged
    @topics = Topic.where(:tags => params[:tag]).active.page(params[:page])
    render :index
  end

  def interesting
    @topics = Topic.where(:tags.in => current_user.favorite_tags).active.page(params[:page])
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

  def mark
    @topic.mark_by current_user
    redirect_referrer_or_default @topic
  end

  def unmark
    @topic.unmark_by current_user
    redirect_referrer_or_default @topic
  end

  protected
  
  def find_topic
    @topic = Topic.number(params[:id])
  end

  def find_user_topic
    @topic = current_user.topics.number(params[:id])
  end
end
