class Entry < ApplicationRecord
  belongs_to :account
  belongs_to :category

  enum entry_type: { revenue: 'revenue', expense: 'expense' }

  validate :value_not_negative
  validate :check_account_balance_if_billed_true, if: :expense?
  
  private

  def check_account_balance_if_billed_true
    if billed && billed_changed?
      return if account.balance >= value

      errors.add(:value, 'Expense amount exceeds account balance')
    end
  end

  def value_not_negative
    if value.negative?
      errors.add(:value, 'cannot be negative')
    end
  end
end
