FactoryBot.define do
  factory :farmer do
    Faker::Config.locale = :ja

    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    farm_address { Faker::Lorem.characters(number: 10) }
    store_address { Faker::Address.full_address }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end
