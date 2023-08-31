class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :entries do |t|
      t.string :description
      t.float :value
      t.date :date
      t.boolean :billed
      t.string :entry_type
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
