class Account < ApplicationRecord
  before_create :set_default_balance

  has_many :entries

  private

  def set_default_balance
    self.balance ||= 0
  end
end
