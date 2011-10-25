class Notification::Base
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  store_in :notifications

  field :read, :default => false

  scope :unread, where(:read => false)

  belongs_to :user
end
