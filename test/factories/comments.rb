# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    content 'content'
    association :user
    association :resource
  end
end
