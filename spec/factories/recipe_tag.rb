FactoryBot.define do
  factory :recipe_tag do
    recipe
    tag { FactoryBot.create(:tag) }
  end
end