FactoryBot.define do
  factory :recipe do
    Faker::Config.locale = :ja
    farmer { FactoryBot.create(:farmer) }

    title { Faker::Lorem.characters(number: 10) }
    recipe_image_id { Faker::Lorem.characters(number: 30) }
    duration { Faker::Number.number(digits: 2) }
    amount{ Faker::Number.number(digits: 1) }
    ingredient { Faker::Lorem.paragraph }
    recipe { Faker::Lorem.paragraph }
    # tag, recipe_tag用のパラメータ
    tag_ids { Faker::Lorem.words }

    after(:create) do
      tag { FactoryBot.create(:tag) }
    end
  end
end