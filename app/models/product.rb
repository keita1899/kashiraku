class Product < ApplicationRecord
  include NutritionCalculatable
  include CostCalculatable

  CATEGORIES = %w[焼き菓子 生菓子 チョコレート パン 和菓子 アイス・冷菓 ドリンク その他].freeze

  belongs_to :user
  has_one :food_label, dependent: :destroy
  has_many :product_materials, dependent: :destroy
  has_many :materials, through: :product_materials
  has_many :material_allergens, through: :materials
  has_many :allergens, -> { distinct.order(required: :desc, id: :asc) }, through: :material_allergens
  accepts_nested_attributes_for :product_materials, allow_destroy: true

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :sales_price, presence: true, numericality: { greater_than: 0 }

  def required_allergens
    allergens.where(required: true)
  end

  def recommended_allergens
    allergens.where(required: false)
  end

  def sorted_ingredient_names
    sorted_materials(additive: false)
  end

  def sorted_additive_names
    sorted_materials(additive: true)
  end

  def allergen_label_names
    allergens.map(&:label_name).uniq
  end

  private

  def sorted_materials(additive:)
    product_materials
      .select { |pm| pm.material&.additive? == additive }
      .sort_by { |pm| -(pm.quantity || 0) }
      .map { |pm| pm.material.display_name.presence || pm.material.name }
  end
end
