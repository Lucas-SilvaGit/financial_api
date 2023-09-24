namespace :dev do
  desc "Configure the development environment"
  task setup: :environment do
    
    # Creating accounts
    puts "Registering accounts..."

    accounts = %w(Nubank Caixa Digio Inter C6)

    accounts.each do |account|
      Account.create!(
        name: account,
        balance: Faker::Number.decimal(l_digits: 4, r_digits: 2)
      )
    end

    puts "Accounts successfully registered!"   
    # end Create accounts
    
    # -------

    # Create Categories
    puts "Creating Categories..."

    categories = %w(Despesas_fixas Despesas_variaveis Moradia Alimentacao)

    categories.each do |category|
      Category.create!(
        description: category
      )
    end

    puts "Categories successfully registered!"
    # end Create Categories
    
    # -------

    # Create Entries
    puts "Registering Entries"
    
    accounts = Account.all
    categories = Category.all

    20.times do |i|
      account = accounts.sample
      category = categories.sample
      entry_type = %w[revenue expense].sample

      Entry.create!(
        description: Faker::TvShows::BigBangTheory.character,
        value: Faker::Number.decimal(l_digits: 3, r_digits: 2),
        date: Faker::Date.between(from: '2023-09-23', to: '2023-09-30'),
        billed: Faker::Boolean.boolean,
        entry_type: entry_type,
        category_id: category.id,
        account_id: account.id
      )
    end

    puts "Entries successfully registered!"
    # end Create Entries
  end
end
