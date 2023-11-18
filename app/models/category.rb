class Category < ApplicationRecord
  has_many :entries, dependent: :destroy

  validates :description, presence: true, uniqueness: true
end
