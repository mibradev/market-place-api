class Order < ApplicationRecord
  validates :total, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 99999.99, allow_nil: true }

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements
end
