FactoryBot.define do
  factory :schedule do
    event

    date { Date.current }
    start_time { Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 1, period: :morning) }
    end_time { Faker::Time.between_dates(from: Date.today + 2, to: Date.today + 2, period: :day) }
    people { Faker::Number.within(range: 1..5) }
  end
end