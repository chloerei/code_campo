class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::NumberId
  include Mentionable

  field :content
  field :mentioned_user_ids, :type => Array, :default => []

  belongs_to :user
  belongs_to :topic
  has_one :notification_topic_reply, :class_name => 'Notification::TopicReply', :dependent => :delete

  validates :content, :user, :topic, :presence => true

  after_create :update_topic, :send_topic_reply_notification
  after_destroy :reset_topic

  attr_accessible :content

  def update_topic
    topic.update_reply_stats_by(self)
    topic.reply_by user
    topic.inc :replies_count, 1
  end

  def reset_topic
    topic.reset_reply_stats
    topic.inc :replies_count, -1
  end

  def edited?
    updated_at > created_at
  end

  def anchor
    "reply-#{number_id}"
  end

  def send_topic_reply_notification
    if user != topic.user
      Notification::TopicReply.create :user => topic.user, :reply => self
    end
  end

  def no_mention_users
    [user, topic.user]
  end
end
