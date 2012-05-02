class HomepageController < ApplicationController
  def index
    @topics = Topic.active.limit(15)
    @users_count = User.count
    @topics_count = Topic.count
    @replies_count = Reply.count
  end
end
