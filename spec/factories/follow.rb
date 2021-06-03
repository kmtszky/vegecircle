FactoryBot.define do
  factory :follow do
    customer { FactoryBot.create(:customer) }
    farmer { FactoryBot.create(:farmer) }
  end
end