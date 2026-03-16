class Material < ApplicationRecord
  ALLOWED_UNITS = %w[g ml].freeze
  UNIT_PRICE_SCALE = 4

  belongs_to :user
  has_many :material_allergens, dependent: :destroy
  has_many :allergens, -> { order(required: :desc, id: :asc) }, through: :material_allergens

  validates :name, presence: true
  validates :purchase_price, presence: true, numericality: { greater_than: 0 }
  validates :purchase_quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true, inclusion: { in: ALLOWED_UNITS }

  before_validation :calculate_unit_price

  private

  def calculate_unit_price
    if purchase_price&.positive? && purchase_quantity&.positive?
      self.unit_price = (purchase_price / purchase_quantity).round(UNIT_PRICE_SCALE)
    else
      self.unit_price = 0
    end
  end
end
