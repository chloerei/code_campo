# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource do
    sequence(:title){|n| "resouce title #{n}" }
    sequence(:url){|n| "http://codecampo.com/topics/#{n}" }
    tags %w(ruby programing)
    association :user
  end
end
