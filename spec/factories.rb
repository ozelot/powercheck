include ActionDispatch::TestProcess

FactoryGirl.define do
  
  factory :user do
    sequence(:email) { |n| "person_#{n+1}@powercheck.biz"}
    password "foobar"
    password_confirmation "foobar"
    
    trait :admin do
      admin true
    end

    factory :user_with_imports do
      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the imports
      after(:create) do |user|
        create_list(:import, 2, user: user)
      end
    end

    factory :user_with_devices do
      after(:create) do |user|
        create_list(:device, 2, user: user)
      end
    end

    factory :user_with_devices_and_imports do
      after(:create) do |user|
        create_list(:device_with_imports, 2, user: user)
      end
    end
  end

  factory :device do
    association :user, factory: :user

    factory :device_with_imports do
      after(:create) do |device|
        create_list(:import, 2, device: device)
      end
    end
  end

  factory :import do
    association :user, factory: :user
    association :device, factory: :device
    import_file { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.xml'), 'text/xml') }
  end

  factory :examination do
    association :device, factory: :device
  end

end
