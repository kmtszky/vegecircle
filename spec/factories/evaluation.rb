FactoryBot.define do
  factory :evaluation do
    Faker::Config.locale = :ja
    customer { FactoryBot.create(:customer) }
    farmer { FactoryBot.create(:farmer) }
    evaluation { 1.5 }
    comment { Faker::Lorem.characters(number: 20) }
  end
end