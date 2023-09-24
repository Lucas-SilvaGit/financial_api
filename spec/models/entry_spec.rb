require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:account) { create(:account, balance: 1000) }

  it "displays an error message if the expense exceeds the account balance" do
    entry = build(:entry, account: account, entry_type: 'expense', billed: true, value: 1500)

    expect(entry).to_not be_valid
    expect(entry.errors[:value]).to include('Expense amount exceeds account balance')
  end

  it "does not display an error message if the expense does not exceed the account balance" do
    entry = build(:entry, account: account, entry_type: 'expense', billed: true, value: 500)

    expect(entry).to be_valid
  end

  context "raises an error" do
    it "when entry expense value exceeds account balance" do
      account = create(:account, balance: 500)
      expense_entry = build(:entry, account: account, entry_type: 'expense', billed: true, value: 600)
      
      expect { expense_entry.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Value Expense amount exceeds account balance')
    end
  end    
end
