# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_topic_reply, :class => Notification::TopicReply, :parent => :notification_base do
    association :reply
  end
end
