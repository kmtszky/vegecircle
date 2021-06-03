FactoryBot.define do
  factory :recipe_tag do
    recipe { FactoryBot.create(:recipe) }
    tag { FactoryBot.create(:tag) }
  end
end