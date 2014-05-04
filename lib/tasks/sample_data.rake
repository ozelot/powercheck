namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  admin = User.create!(email: "admin@powercheck.biz",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true)    
99.times do |n|
      email = "example-#{n+1}@powercheck.biz"
      password  = "password"
      User.create!(email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end