FactoryBot.define do
  factory :account do
    name { Faker::Company.name }
    balance { Faker::Number.decimal(l_digits: 2) }
  end
end
