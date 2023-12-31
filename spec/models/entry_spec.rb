require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:account) { create(:account, balance: 0) }

  it 'calculates the account balance correctly for expense entries' do
    entry = create(:entry, account: account, entry_type: 'revenue', billed: true, value: 300)
    account.calculate_balance

    expect(account.reload.balance).to eq(300)
  end

  it "displays an error message if the expense exceeds the account balance" do
    entry = build(:entry, account: account, entry_type: 'expense', billed: true, value: 1500)

    expect(entry).to_not be_valid
    expect(entry.errors[:value]).to include('Expense amount exceeds account balance')
  end

  it "does not display an error message if the expense does not exceed the account balance" do
    account = create(:account, balance: 700)
    entry = build(:entry, account: account, entry_type: 'expense', billed: true, value: 500)

    expect(entry).to be_valid
  end

  context "raises an error" do
    it "when entry expense value exceeds account balance" do
      account = create(:account, balance: 500)
      expense_entry = build(:entry, account: account, entry_type: 'expense', billed: true, value: 600)
      
      expect { expense_entry.save! }.to raise_error(ActiveRecord::RecordInvalid, /Expense amount exceeds account balance/)
    end

    it "displays an error message if the expense has a negative value" do
      entry = build(:entry, account: account, entry_type: 'expense', billed: true, value: -300)
    
      expect(entry).to_not be_valid
      expect(entry.errors[:value]).to include('cannot be negative')
    end
    

    it 'displays an error message if the revenue has a negative value' do
      entry = build(:entry, account: account, entry_type: 'revenue', billed: true, value: -300)

      expect(entry).to_not be_valid
      expect(entry.errors[:value]).to include('cannot be negative')
    end
  end    
end
