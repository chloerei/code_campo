class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::NumberId
  include Mongo::Voteable

  voteable self, :up => 1

  field :content

  belongs_to :user
  belongs_to :resource
  has_many :children, :class_name => 'Comment', :as => :parent, :dependent => :destroy
  belongs_to :parent, :class_name => 'Comment'

  validates :content, :user, :resource, :presence => true

  after_create :update_resource

  attr_accessible :content

  def update_resource
    resource.inc :comments_count, 1
  end

  def anchor
    "comment-#{number_id}"
  end
end
