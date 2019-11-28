class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, allow_nil: true }
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
end
