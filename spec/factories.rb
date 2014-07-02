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
        create_list(:report, 2, user: user)
      end
    end

    factory :user_with_devices do
      after(:create) do |user|
        create_list(:device, 2, user: user)
      end
    end

    factory :user_with_devices_and_reports do
      after(:create) do |user|
        create_list(:device_with_reports, 2, user: user)
      end
    end
  end

  factory :device do
    user

    factory :device_with_reports do
      after(:create) do |device|
        create_list(:report, 2, device: device)
      end
    end
  end

  factory :report do
    user
    device
    report_file { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.xml'), 'text/xml') }
  end

end
