  class Account < ApplicationRecord
    paginates_per 10

    before_create :set_default_balance
    has_many :entries

    validates :balance, numericality: { greater_than_or_equal_to: 0 }

    def calculate_balance
      self.balance = calculate_total_revenue - calculate_total_expenses

      save
    end
    
    def as_json(options = {})
      super(options.merge({ methods: :balance }))
    end
    
    private

    def calculate_total_revenue
      entries.where(entry_type: 'revenue', billed: true).sum(:value)
    end
  
    def calculate_total_expenses
      entries.where(entry_type: 'expense', billed: true).sum(:value)
    end

    def set_default_balance
      self.balance ||= 0
    end
  end
