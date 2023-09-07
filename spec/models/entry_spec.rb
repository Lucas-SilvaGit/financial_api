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
end