class Admin::TopicsController < Admin::BaseController
  before_filter :find_topic, :except => :index

  def index
    @topics = Topic.order_by([:created_at, :desc]).page(params[:page])
  end

  def show
  end

  def destroy
    @topic.destroy
    flash[:success] = I18n.t('admin.topics.destroy.delete_success', :title => @topic.title)
    redirect_to :action => :index
  end

  protected

  def find_topic
    @topic = Topic.number(params[:id])
  end
end
