class AddAccountReferenceToEntries < ActiveRecord::Migration[6.1]
  def change
    add_reference :entries, :account, null: false, foreign_key: true
  end
end
