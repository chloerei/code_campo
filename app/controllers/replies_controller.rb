class RepliesController < ApplicationController
  before_filter :require_logined
  before_filter :find_topic, :only => [:new, :create]

  def new
    @reply = current_user.replies.new :topic => @topic
  end

  def create
    @reply = current_user.replies.new params[:reply]
    @reply.topic = @topic
    if @reply.save
      redirect_to @topic
    else
      render :new
    end
  end

  protected

  def find_topic
    @topic = Topic.number params[:topic_id]
  end
end
