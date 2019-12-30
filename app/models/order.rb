class Order < ApplicationRecord
  before_validation :set_total!

  validates :total, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 99999.99, allow_nil: true }
  validates_with EnoughProductsValidator

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      placement = placements.build(
        product_id: product_id_and_quantity[:product_id],
        quantity: product_id_and_quantity[:quantity]
      )
      yield placement if block_given?
    end
  end

  def set_total!
    self.total = self.placements.map do |placement|
      placement.product.price * placement.quantity
    end.sum
  end
end
