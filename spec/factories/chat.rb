FactoryBot.define do
  factory :chat do
    Faker::Config.locale = :ja
    farmer { FactoryBot.create(:farmer) }
    customer { FactoryBot.create(:customer) }
    event { FactoryBot.create(:event) }

    chat { Faker::Lorem.characters(number: 20) }
  end
end
