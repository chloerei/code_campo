class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::NumberId

  field :content

  belongs_to :user
  belongs_to :topic
  has_and_belongs_to_many :mentioned_users, :class_name => 'User'

  validates :content, :user, :topic, :presence => true

  before_save :extract_mentioned_users
  after_create :update_topic, :send_mention_notification

  attr_accessible :content

  def update_topic
    topic.update_attribute :actived_at, self.created_at
    topic.reply_by user
    topic.inc :replies_count, 1
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
      self.mentioned_users = User.where(:name => /^(#{names.join('|')})$/i, :_id.ne => user.id).limit(5).to_a
    end
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
