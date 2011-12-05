# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_comment_comment, :class => Notification::CommentComment, :parent => :notification_base do
    association :comment
  end
end
