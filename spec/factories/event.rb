FactoryBot.define do
  factory :event do
    Faker::Config.locale = :ja
    farmer { FactoryBot.create(:farmer) }

    title { Faker::Lorem.characters(number: 10) }
    plan_image_id { Faker::Lorem.characters(number: 30) }
    body { Faker::Lorem.paragraph }
    fee { Faker::Number.number(digits: 3) }
    cancel_change { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    access { Faker::Lorem.characters(number: 10) }
    start_date { Date.current }
    end_date { Date.current + 2 }

    # Schedule用パラメータ
    start_time { Faker::Time.between_dates(from: DateTime.now, to: DateTime.now + 1, period: :morning) }
    end_time { Faker::Time.between_dates(from: DateTime.now + 1, to: DateTime.now + 2, period: :day) }
    number_of_participants { Faker::Number.number(digits: 2) }

    after(:create) do |event|
      FactoryBot.create(:schedule)
    end
  end
end