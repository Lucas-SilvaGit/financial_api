FactoryBot.define do
  factory :account do
    name { Faker::Company.name }
    self.balance { 2000 }
  end
end
