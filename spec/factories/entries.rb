FactoryBot.define do
  factory :entry do
    description { Faker::Name.name}
    value { Faker::Number.decimal(l_digits: 2) }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    billed { true}
    category_id { 1 }

    association :category, factory: :category  # Adicione essa linha para associar a uma categoria existente
    association :account, factory: :account 
  end
end
