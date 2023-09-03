  class Account < ApplicationRecord
    before_create :set_default_balance
    has_many :entries

    def calculate_balance
      total_expenses = entries.where(entry_type: 'despesa', billed: true).sum(:value)
      total_revenue = entries.where(entry_type: 'receita', billed: true).sum(:value)

      self.balance = total_revenue - total_expenses

      save
    end
    
    def as_json(options = {})
      super(options.merge({ methods: :balance }))
    end
    
    private

    def set_default_balance
      self.balance ||= 0
    end
  end
