class ResourcesController < ApplicationController
  before_filter :require_logined, :except => [:index, :tagged, :show]

  def index
    @resources = Resource.order_by([[:created_at, :desc]]).page(params[:page])
  end

  def tagged
    @resources = Resource.where(:tags => params[:tag]).order_by([[:created_at, :desc]]).page(params[:page])
    render :index
  end

  def show
    @resource = Resource.number params[:id]
    @relate_resources = @resource.relate_resources(5)
    @comments = @resource.comments.order_by([["votes.point", :desc], [:created_at, :asc]]).to_a
  end

  def new
    @resource = Resource.new :tag_string => params[:tag]
  end

  def create
    @resource = current_user.resources.new params[:resource]
    if @resource.save
      flash[:success] = 'Success Submit Resource.'
      redirect_to @resource
    else
      render :new
    end
  end

  def vote_up
    @resource = Resource.number params[:id]
    current_user.vote(@resource, :up)
    redirect_referrer_or_default @resource
  end

  def unvote_up
    @resource = Resource.number params[:id]
    current_user.unvote(@resource)
    redirect_referrer_or_default @resource
  end
end
