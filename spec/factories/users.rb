require 'faker'

FactoryGirl.define do
  factory :user do
    factory :complete_user do
      username Faker::Internet.user_name
      password Faker::Internet.password
    end
  end
end