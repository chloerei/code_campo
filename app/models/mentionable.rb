module Mentionable
  extend ActiveSupport::Concern

  included do
    field :mentioned_user_ids, :type => Array, :default => []
    before_save :extract_mentioned_users
    after_create :send_mention_notification
    has_many :notification_mentions, :as => :mentionable, :class_name => 'Notification::Mention', :dependent => :delete
  end

  module InstanceMethods
    def mentioned_users
      User.where(:_id.in => mentioned_user_ids)
    end

    def mentioned_user_names
      mentioned_users.map(&:name)
    end

    def extract_mentioned_users
      names = content.scan(/@(\w{3,20})(?![.\w])/).flatten
      if names.any?
        self.mentioned_user_ids = User.where(:name => /^(#{names.join('|')})$/i, :_id.ne => user.id).limit(5).only(:_id).map(&:_id).to_a
      end
    end

    def send_mention_notification
      mentioned_users.each do |user|
        Notification::Mention.create :user => user, :mentionable => self
      end
    end
  end
end
