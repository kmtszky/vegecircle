FactoryBot.define do
  factory :schedule do
    event

    date { event.start_date }
    start_time { Faker::Time.between_dates(from: event.start_date + 1, to: event.start_date + 1, period: :morning) }
    end_time { Faker::Time.between_dates(from: event.start_date + 2, to: event.start_date + 2, period: :day) }
    people { Faker::Number.within(range: 1..5) }
  end
end