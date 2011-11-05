class HomepageController < ApplicationController
  def index
    @resources = Resource.order_by([[:created_at, :desc]]).limit(5)
    @topics = Topic.active.limit(10)
  end
end
