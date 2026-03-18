class ProductMaterial < ApplicationRecord
  belongs_to :product
  belongs_to :material

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
