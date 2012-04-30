class Admin::SitesController < Admin::BaseController
  def show
  end

  def update
    if @site.update_attributes params[:site].slice(:name)
      flash[:success] = "Success"
      redirect_to :action => :show
    else
      render :show
    end
  end
end
