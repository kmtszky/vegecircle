FactoryBot.define do
  factory :reservation do
    customer
    schedule
    people { Faker::Number.within(range: 1..10) }
  end
end