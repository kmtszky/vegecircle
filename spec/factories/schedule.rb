FactoryBot.define do
  factory :schedule do
    event { FactoryBot.create(:event) }
    date { Date.current }
    start_time { Faker::Time.between_dates(from: DateTime.now, to: DateTime.now + 1, period: :morning) }
    end_time { Faker::Time.between_dates(from: DateTime.now + 1, to: DateTime.now + 2, period: :day) }
    people { Faker::Number.number(digits: 2) }
  end
end