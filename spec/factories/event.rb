FactoryBot.define do
  factory :event do
    Faker::Config.locale = :ja
    farmer

    title { Faker::Lorem.characters(number: 10) }
    plan_image_id { Faker::Lorem.characters(number: 30) }
    body { Faker::Lorem.paragraph }
    fee { Faker::Number.number(digits: 3) }
    cancel_change { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    access { Faker::Lorem.characters(number: 10) }
    start_date { Date.current + 2 }
    end_date { Date.current + 3 }

    # Schedule用パラメータ
    start_time { Faker::Time.between_dates(from: Date.today, to: Date.today + 1, period: :morning) }
    end_time { Faker::Time.between_dates(from: Date.today + 2, to: Date.today + 3, period: :day) }
    number_of_participants { Faker::Number.number(digits: 2) }
  end
end