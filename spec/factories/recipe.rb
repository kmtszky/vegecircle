FactoryBot.define do
  factory :recipe do
    Faker::Config.locale = :ja
    farmer

    title { Faker::Lorem.characters(number: 10) }
    recipe_image_id { Faker::Lorem.characters(number: 30) }
    duration { Faker::Number.number(digits: 2) }
    amount{ Faker::Number.number(digits: 1) }
    ingredient { Faker::Lorem.paragraph }
    recipe { Faker::Lorem.paragraph }

    #タグ用パラメータ
    tag_list { Faker::Lorem.words.split(',') }
    #after(:create) do |recipe|
    #  recipe.save_tags(tag_list)
    #end
  end
end