class Notification::Base
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  store_in :notifications

  belongs_to :user
end
