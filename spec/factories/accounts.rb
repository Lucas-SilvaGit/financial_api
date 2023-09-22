FactoryBot.define do
  factory :account do
    name { Faker::Company.name }
    balance { 0 }
  end
end
