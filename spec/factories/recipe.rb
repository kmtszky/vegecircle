FactoryBot.define do
  factory :recipe do
    Faker::Config.locale = :ja
    farmer

    title { Faker::Lorem.characters(number: 10) }
    recipe_image_id { Faker::Lorem.characters(number: 30) }
    duration { Faker::Number.within(range: 10..90) }
    amount{ Faker::Number.within(range: 1..10) }
    ingredient { Faker::Lorem.paragraph }
    recipe { Faker::Lorem.paragraph }

    #タグ用パラメータ
    tag_list { Faker::Lorem.words.split(',') }

    trait :with_tag_lists do
      after(:build) do |recipe|
        recipe.save_tags(recipe.tag_list)
      end
    end

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end
  end
end