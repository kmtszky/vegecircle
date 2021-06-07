FactoryBot.define do
  factory :customer do
    nickname { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end