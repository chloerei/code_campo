# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    title 'title'
    content 'content'
    tags %w(ruby programing)
    association :user
  end
end
