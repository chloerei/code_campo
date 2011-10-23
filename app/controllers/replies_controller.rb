class RepliesController < ApplicationController
  before_filter :require_logined
  before_filter :find_topic, :only => [:new, :create]
  respond_to :html, :js, :only => [:create]

  def new
    @reply = current_user.replies.new :topic => @topic
  end

  def create
    @reply = current_user.replies.new params[:reply]
    @reply.topic = @topic
    respond_with(@reply) do |format|
      if @reply.save
        format.html { redirect_to topic_url(@topic, :page => @topic.last_page, :anchor => @topic.last_anchor) }
        format.js { render :create, :layout => false }
      else
        format.html { render :new }
        format.js { render :text => @reply.errors.full_messages.join(','), :status => 406, :layout => false }
      end
    end
  end

  protected

  def find_topic
    @topic = Topic.number params[:topic_id]
  end
end
