require 'rails_helper'

RSpec.describe Account, type: :model do
  it "validates account with positive balance" do
    account = build(:account, balance: 1000)
    expect(account).to be_valid
  end

  it "validates account with zero balance" do
    account = build(:account, balance: 0)
    expect(account).to be_valid
  end  

  it "is invalid with a negative balance" do
    account = build(:account, balance: -500)
    expect(account).to_not be_valid
  end

  context "when account has billed entries" do
    it "calculates the balance correctly" do
      account = create(:account)
      
      revenue_entry = create(:entry, account: account, entry_type: 'revenue', billed: true, value: 1500)
      account.calculate_balance

      expense_entry = create(:entry, account: account, entry_type: 'expense', billed: true, value: 300)
      account.calculate_balance
  
      expect(account.balance).to eq(1200)
    end    
  end
  
  context "when account not has billed entries" do
    it 'balance with revenue not billed' do
      account = create(:account, balance: 0)

      revenue_entry = create(:entry, account: account, entry_type: 'revenue', billed: false, value: 800)
      account.calculate_balance

      expect(account.balance).to eq(0)
    end
    
    it 'balance with expense not billed' do
      account = create(:account, balance: 0)

      revenue_entry = create(:entry, account: account, entry_type: 'expense', billed: false, value: 800)
      account.calculate_balance

      expect(account.balance).to eq(0)
    end
  end

  it 'has many entries' do
    account = create(:account, balance: 0)
    entry1 = create(:entry, account: account, entry_type: 'revenue', billed: false, value: 200)
    entry2 = create(:entry, account: account, entry_type: 'expense', billed: false, value: 100)

    expect(account.entries).to include(entry1, entry2)  
  end

  it 'destroy associated entries when account destroyed' do
    account = create(:account, balance: 0)
    entry1 = create(:entry, account: account)

    expect{ account.destroy }.to change { Entry.count }.by(-1)
  end
end
