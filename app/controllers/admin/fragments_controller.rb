class Admin::FragmentsController < Admin::BaseController
  before_filter :find_field, :except => :index

  def index
  end

  def edit
  end

  def update
    if @site.fragment.update_attribute @field, params[:fragment][@field]
      flash[:success] = "Success"
      redirect_to :action => :edit, :id => @field
    else
      flash.now[:error] = "Error: #{@site.fragment.erros.full_messages}"
      render :edit
    end
  end

  protected

  def find_field
    if Fragment::FIELDS.include?(params[:id])
      @field = params[:id]
    else
      flash[:error] = 'Fragment field no exist'
      redirect_to :action => :index
    end
  end
end
