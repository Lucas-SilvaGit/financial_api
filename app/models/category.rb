class Category < ApplicationRecord
  has_many :entries

  validates :description, presence: true, uniqueness: true
end
