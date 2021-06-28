FactoryBot.define do
  factory :reservation do
    customer { FactoryBot.create(:customer) }
    schedule { FactoryBot.create(:schedule) }
    people { Faker::Number.within(range: 1..10) }
  end
end