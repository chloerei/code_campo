class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::NumberId

  field :content

  belongs_to :user
  belongs_to :resource
  belongs_to :parent, :class_name => 'Comment'

  validates :content, :user, :resource, :presence => true

  after_create :update_resource

  attr_accessible :content

  def update_resource
    resource.inc :comments_count, 1
  end
end
