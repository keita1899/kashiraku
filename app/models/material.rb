class Material < ApplicationRecord
  ALLOWED_UNITS = %w[g ml].freeze

  belongs_to :user

  validates :name, presence: true
  validates :purchase_price, presence: true, numericality: { greater_than: 0 }
  validates :purchase_quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true, inclusion: { in: ALLOWED_UNITS }
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
end
