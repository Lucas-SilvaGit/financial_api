class Entry < ApplicationRecord
  belongs_to :account
  belongs_to :category

  enum entry_type: { revenue: 'revenue', expense: 'expense' }

  validate :check_account_balance_if_billed_true, if: :expense?
  
  private

  def check_account_balance_if_billed_true
    if billed && billed_changed?
      return if account.balance >= value

      errors.add(:value, 'Valor da despesa excede o saldo da conta')
    end
  end
end
