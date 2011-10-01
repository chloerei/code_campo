class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::NumberId

  field :content

  belongs_to :user
  belongs_to :topic

  after_create :update_topic

  def update_topic
    topic.update_attribute :actived_at, self.created_at
  end
end
