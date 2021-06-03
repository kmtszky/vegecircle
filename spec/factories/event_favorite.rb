FactoryBot.define do
  factory :event_favorite do
    customer { FactoryBot.create(:customer) }
    event { FactoryBot.create(:event) }
  end
end