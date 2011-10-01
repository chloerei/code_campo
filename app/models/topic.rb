class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::NumberId

  field :title
  field :content
  field :tags,       :type => Array
  field :actived_at, :type => DateTime

  belongs_to :user
  has_many   :replies

  validates :title, :content, :user, :presence => true

  before_create :set_actived_at

  attr_accessible :title, :content

  def set_actived_at
    self.actived_at = Time.now
  end

  def to_param
    self.number_id.to_s
  end

  def edited?
    updated_at > created_at
  end
end
