FactoryBot.define do
  factory :tag do
    tag { Faker::Lorem.word }
  end
end