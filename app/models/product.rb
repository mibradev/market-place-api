class Product < ApplicationRecord
  validates :title, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 9999.99, allow_nil: true }

  belongs_to :user
end
