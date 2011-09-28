FactoryGirl.define do
  factory :reply do
    content 'content'
    association :user
  end
end
