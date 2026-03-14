class Material < ApplicationRecord
  ALLOWED_UNITS = %w[g ml].freeze

  belongs_to :user

  validates :name, presence: true
  validates :purchase_price, presence: true, numericality: { greater_than: 0 }
  validates :purchase_quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true, inclusion: { in: ALLOWED_UNITS }

  before_validation :calculate_unit_price

  private

  def calculate_unit_price
    if purchase_price.present? && purchase_quantity&.positive?
      self.unit_price = purchase_price / purchase_quantity
    else
      self.unit_price = nil
    end
  end
end
