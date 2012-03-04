class Admin::UsersController < Admin::BaseController
  before_filter :find_user, :except => :index

  def index
    @users = User.order_by([:created_at, :desc]).page(params[:page])
  end

  def show
    @topics = @user.topics.order_by([[:created_at, :desc]]).page(1).per(5)
    @replies = @user.replies.order_by([[:created_at, :desc]]).page(1).per(5)
  end

  def destroy
    @user.destroy
    flash[:success] = I18n.t('admin.users.destroy.delete_success', :name => @user.name)
    redirect_to :action => :index
  end

  protected

  def find_user
    @user = User.first :conditions => {:name => /^#{params[:id]}$/i}
    raise Mongoid::Errors::DocumentNotFound.new(User, params[:id]) if @user.nil?
  end
end
