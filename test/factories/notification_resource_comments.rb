# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_resource_comment, :class => Notification::ResourceComment, :parent => :notification_base do
    association :comment
  end
end
