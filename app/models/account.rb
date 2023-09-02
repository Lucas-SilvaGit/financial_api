class Account < ApplicationRecord
  before_create :set_default_balance

  private

  def set_default_balance
    self.balance ||= 0
  end
end
