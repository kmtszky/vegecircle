FactoryBot.define do
  factory :recipe_favorite do
    customer { FactoryBot.create(:customer) }
    recipe { FactoryBot.create(:recipe) }
  end
end