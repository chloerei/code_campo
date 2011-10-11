class ResourcesController < ApplicationController
  before_filter :require_logined, :except => [:index]

  def index
    @resources = Resource.order_by([[:created_at, :desc]]).page(params[:page])
  end

  def new
    @resource = Resource.new
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
end
