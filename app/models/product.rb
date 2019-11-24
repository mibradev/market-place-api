class Product < ApplicationRecord
  validates :title, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 9999.99, allow_nil: true }

  belongs_to :user

  scope :filter_by_title, ->(keyword) { where("LOWER(title) LIKE ?", "%#{keyword.downcase}%") }
  scope :above_or_equal_to_price, ->(price) { where("price >= ?", price) }
  scope :below_or_equal_to_price, ->(price) { where("price <= ?", price) }
  scope :recent, -> { order(updated_at: :desc) }

  class << self
    def search(params = {})
      products = all
      products = products.where(id: params[:product_ids]) if params[:product_ids]
      products = products.filter_by_title(params[:keyword]) if params[:keyword]
      products = products.above_or_equal_to_price(params[:min_price]) if params[:min_price]
      products = products.below_or_equal_to_price(params[:max_price]) if params[:max_price]
      products = products.recent if params[:recent]
      products
    end
  end
end
