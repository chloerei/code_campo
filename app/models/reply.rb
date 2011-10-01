class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::NumberId

  field :content

  belongs_to :user
  belongs_to :topic

  validates :content, :user, :topic, :presence => true

  after_create :update_topic

  attr_accessible :content

  def update_topic
    topic.update_attribute :actived_at, self.created_at
  end
end
