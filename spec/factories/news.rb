FactoryBot.define do
  factory :news do
    Faker::Config.locale = :ja
    farmer { FactoryBot.create(:farmer) }

    news { Faker::Lorem.characters(number: 20) }
  end
end