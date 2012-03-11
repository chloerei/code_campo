FactoryGirl.define do
  factory :tag do
    sequence(:_id){|n| "tag#{n}" }
  end
end
