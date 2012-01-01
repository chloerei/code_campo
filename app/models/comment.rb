class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::NumberId
  include Mongo::Voteable
  include Mentionable

  voteable self, :up => 1

  field :content

  belongs_to :user
  belongs_to :resource
  has_many :children, :class_name => 'Comment', :as => :parent, :dependent => :destroy
  belongs_to :parent, :class_name => 'Comment'
  has_one :notification_comment_comment, :class_name => 'Notification::CommentComment', :dependent => :delete
  has_one :notification_resource_comment, :class_name => 'Notification::ResourceComment', :dependent => :delete

  validates :content, :user, :resource, :presence => true

  after_create :update_resource, :send_resource_comment_notification,
    :send_comment_comment_notification

  attr_accessible :content

  def update_resource
    resource.inc :comments_count, 1
  end

  def anchor
    "comment-#{number_id}"
  end

  def send_resource_comment_notification
    if user != resource.user && parent.blank?
      Notification::ResourceComment.create :user => resource.user, :comment => self
    end
  end

  def send_comment_comment_notification
    if parent.present? && user != parent.user
      Notification::CommentComment.create :user => parent.user, :comment => self
    end
  end

  def no_mention_users
    if parent.present?
      [user, parent.user]
    else
      [user, resource.user]
    end
  end
end
