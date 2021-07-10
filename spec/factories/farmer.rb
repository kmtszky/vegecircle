FactoryBot.define do
  factory :farmer do
    Faker::Config.locale = :ja

    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    farm_address { "栃木県宇都宮市" }
    store_address { "栃木県宇都宮市池上町4-2-5" }
    password { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
  end
end
