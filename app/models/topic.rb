class Topic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :content
  field :tags, :type => Array
  field :actived_at, :type => DateTime

  belongs_to :user

  validates :title, :content, :user, :presence => true
end
