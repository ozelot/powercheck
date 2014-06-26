include ActionDispatch::TestProcess

FactoryGirl.define do
  
  factory :user do
    sequence(:email) { |n| "person_#{n+1}@powercheck.biz"}
    password "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end
    
    factory :user_with_reports do      
      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the report
      after(:create) do |user|
        create_list(:report, 5, user: user)
      end
    end
  end

  factory :report do
    summary "Test passed."
    user = user
    report_file { fixture_file_upload('test.xml', 'text/xml') }
    user
  end

end
