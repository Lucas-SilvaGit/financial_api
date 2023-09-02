class Entry < ApplicationRecord
  belongs_to :account
  belongs_to :category

  enum entry_type: { receita: 'receita', despesa: 'despesa' }
end
