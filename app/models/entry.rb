class Entry < ApplicationRecord
  belongs_to :account
  belongs_to :category

  validate :check_account_balance, if: :despesa?

  enum entry_type: { receita: 'receita', despesa: 'despesa' }

  # before_save :check_account_balance_if_billed_changed

  private

  def check_account_balance
    return if account.balance > 0 && account.balance >= value

    errors.add(:value, 'Expense amount exceeds account balance')
  end

  # def check_account_balance_if_billed_changed
  #   if billed_changed? && billed
  #     # return if account.balance >= 0 && account.balance >= value
  #     return if account.balance >= value

  #     errors.add(:value, 'Expense amount exceeds account balance')
  #   end
  # end
end
