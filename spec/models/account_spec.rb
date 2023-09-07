require 'rails_helper'

RSpec.describe Account, type: :model do
  it "is valid with valid attributes" do
    account = build(:account, balance: 1000)
    expect(account).to be_valid
  end

  it "is invalid with a negative balance" do
    account = build(:account, balance: -500)
    expect(account).to_not be_valid
  end

  it "calculates the balance correctly" do
    account = create(:account)
    create(:entry, account: account, entry_type: 'revenue', billed: true, value: 2000)
    create(:entry, account: account, entry_type: 'expense', billed: true, value: 300)
    
    account.calculate_balance
    expect(account.balance).to eq(1700)
  end
end
