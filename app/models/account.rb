  class Account < ApplicationRecord
    before_create :set_default_balance
    has_many :entries

    validates :balance, numericality: { greater_than_or_equal_to: 0 }

    def calculate_balance
      total_expenses = entries.where(entry_type: 'expense', billed: true).sum(:value)
      total_revenue = entries.where(entry_type: 'revenue', billed: true).sum(:value)

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
