FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person_#{n+1}@powercheck.biz"}
    password "foobar"
    password_confirmation "foobar"
  end
end
