class CommentsController < ApplicationController
  before_filter :require_logined
  respond_to :html, :js, :only => :create

  def new
    @resource = Resource.number params[:resource_id]
    @parent = Comment.number params[:parent_id] if params[:parent_id]
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new params[:comment]
    @comment.resource = @resource = Resource.number(params[:resource_id])
    @comment.parent = @parent = Comment.number(params[:parent_id]) if params[:parent_id]
    respond_with(@comment) do |format|
      if @comment.save
        format.html {
          flash[:success] = 'Success Post Comment.'
          redirect_to resource_url(@comment.resource, :anchor => @comment.anchor)
        }
        format.js { render :create, :layout => false }
      else
        format.html { render :new }
        format.js { render :text => @comment.errors.full_messages.join(','), :status => 406, :layout => false }
      end
    end
  end

  def vote_up
    @comment = Comment.number params[:id]
    current_user.vote(@comment, :up)
    redirect_to resource_path(@comment.resource, :anchor => @comment.anchor)
  end
end
