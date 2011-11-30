class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::NumberId

  field :content
  field :mentioned_user_ids, :type => Array, :default => []

  belongs_to :user
  belongs_to :topic

  validates :content, :user, :topic, :presence => true

  before_save :extract_mentioned_users
  after_create :update_topic, :send_mention_notification
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

  def extract_mentioned_users
    names = content.scan(/@(\w{3,20})(?![.\w])/).flatten
    if names.any?
      self.mentioned_user_ids = User.where(:name => /^(#{names.join('|')})$/i, :_id.ne => user.id).limit(5).only(:_id).map(&:_id).to_a
    end
  end

  def mentioned_users
    User.where(:_id.in => mentioned_user_ids)
  end

  def mentioned_user_names
    mentioned_users.map(&:name)
  end

  def send_mention_notification
    mentioned_users.each do |user|
      Notification::Mention.create :user => user, :reply => self
    end
  end
end
