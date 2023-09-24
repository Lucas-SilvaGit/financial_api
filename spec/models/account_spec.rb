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

  context "when billed" do
    it "calculates the balance correctly" do
      account = create(:account)
      
      revenue_entry = create(:entry, account: account, entry_type: 'revenue', billed: true, value: 1500)
      account.calculate_balance

      expense_entry = create(:entry, account: account, entry_type: 'expense', billed: true, value: 300)
      account.calculate_balance
  
      expect(account.balance).to eq(1200)
    end    
  end
  
  context "when not billed entry" do
    it 'calculates the balance correctly with entry revenue not billed' do
      account = create(:account)

      required_revenue_entry = create(:entry, account: account, entry_type: 'revenue', billed: false, value: 800)
      account.calculate_balance
      expect(account.balance).to eq(0)

      expense_entry = build(:entry, account: account, entry_type: 'expense', billed: true, value: 200)

      expect(expense_entry).to_not be_valid
      expect(expense_entry.errors[:value]).to include('Expense amount exceeds account balance')
    end    
    
    it 'calculates the balance correctly with entry expense not billed' do
      account = create(:account)

      revenue_entry = create(:entry, account: account, entry_type: 'revenue', billed: true, value: 800)
      account.calculate_balance
      expect(account.balance).to eq(800)

      required_expense_entry = build(:entry, account: account, entry_type: 'expense', billed: false, value: 200)
      expect(account.balance).to eq(800)
    end    
  end
end
