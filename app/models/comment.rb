class Comment
  include Mongoid::Document

  field :content

  belongs_to :user
  belongs_to :resource

  validates :content, :user, :resource, :presence => true

  after_create :update_resource

  attr_accessible :content

  def update_resource
    resource.inc :comments_count, 1
  end
end
