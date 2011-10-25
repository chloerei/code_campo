# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_base, :class => Notification::Base do
    association :user
  end
end
