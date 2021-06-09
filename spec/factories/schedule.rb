FactoryBot.define do
  factory :schedule do
    event { FactoryBot.create(:event) }
    date { Date.current }
    start_time { Faker::Time.between_dates(from: Date.today, to: Date.today + 1, period: :morning) }
    end_time { Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 2, period: :day) }
    people { Faker::Number.number(digits: 2) }
  end
end