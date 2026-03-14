class Material < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :purchase_price, presence: true, numericality: { greater_than: 0 }
  validates :purchase_quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true, inclusion: { in: %w[g ml] }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
end
