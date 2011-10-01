FactoryGirl.define do
  factory :reply do
    content 'content'
    association :user
    association :topic
  end
end
