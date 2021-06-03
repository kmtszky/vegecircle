FactoryBot.define do
  factory :reservation do
    customer { FactoryBot.create(:customer) }
    schedule { FactoryBot.create(:schedule) }
    people { Faker::Number.number(digits: 1) }
  end
end