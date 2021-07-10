FactoryBot.define do
  factory :recipe_favorite do
    recipe
    customer
  end
end