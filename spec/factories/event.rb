FactoryBot.define do
  factory :event, class: Event do
    Faker::Config.locale = :ja
    farmer

    title { Faker::Lorem.characters(number: 10) }
    plan_image_id { Faker::Lorem.characters(number: 30) }
    body { Faker::Lorem.paragraph }
    fee { Faker::Number.within(range: 100..1000) }
    cancel_change { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    access { Faker::Lorem.characters(number: 10) }
    start_date { Date.current + 1 }
    end_date { Date.current + 2 }

    # Schedule用パラメータ
    start_time { Faker::Time.between_dates(from: Date.current + 1, to: Date.current + 1, period: :morning) }
    end_time { Faker::Time.between_dates(from: Date.current + 2, to: Date.current + 2, period: :day) }
    number_of_participants { Faker::Number.within(range: 10..20) }

    trait :with_schedules do
      after(:build) do |event|
        event.start_date.step(event.start_date + (event.end_date - event.start_date), 1) do |date|
          event.schedules << FactoryBot.create(:schedule, event: event, date: date, start_time: event.start_time, end_time: event.end_time, people: event.number_of_participants)
        end
      end
    end

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end
  end
end