FactoryBot.define do
  factory :farmer do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    farm_address { Faker::Lorem.characters(number: 10) }
    store_address { Faker::Address.full_address }
    password { Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end
