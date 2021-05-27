FactoryBot.define do
  factory :news do
    news { Faker::Lorem.characters(number: 20) }
    farmer
  end
end