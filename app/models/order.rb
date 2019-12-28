class Order < ApplicationRecord
  before_validation :set_total!

  validates :total, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 99999.99, allow_nil: true }

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  private
    def set_total!
      self.total = products.map(&:price).sum
    end
end
