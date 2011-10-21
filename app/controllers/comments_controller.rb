class CommentsController < ApplicationController
  before_filter :require_logined

  def new
    @resource = Resource.number params[:resource_id]
    @parent = Comment.number params[:parent_id] if params[:parent_id]
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new params[:comment]
    @comment.resource = @resource = Resource.number(params[:resource_id])
    @comment.parent = @parent = Comment.number(params[:parent_id]) if params[:parent_id]
    if @comment.save
      flash[:success] = 'Success Post Comment.'
      redirect_to resource_url(@comment.resource, :anchor => @comment.anchor)
    else
      render :new
    end
  end
end
