class Admin::RepliesController < Admin::BaseController
  before_filter :find_reply, :except => :index

  def index
    @replies = Reply.order_by([:created_at, :desc]).page(params[:page])
  end

  def show
  end

  def destroy
    @reply.destroy
    flash[:success] = I18n.t('admin.replies.destroy.delete_success')
    redirect_to :action => :index
  end

  protected

  def find_reply
    @reply = Reply.number(params[:id])
  end
end
