class Material < ApplicationRecord
  ALLOWED_UNITS = %w[g ml].freeze
  UNIT_PRICE_SCALE = 4

  belongs_to :user
  has_many :product_materials, dependent: :destroy
  has_many :products, through: :product_materials
  has_many :material_allergens, dependent: :destroy
  has_many :allergens, -> { order(required: :desc, id: :asc) }, through: :material_allergens

  validates :name, presence: true
  validates :purchase_price, presence: true, numericality: { greater_than: 0 }
  validates :purchase_quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true, inclusion: { in: ALLOWED_UNITS }
  validates :energy, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :protein, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :fat, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :carbohydrate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :salt, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

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
