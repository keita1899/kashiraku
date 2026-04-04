class FoodLabel < ApplicationRecord
  PRODUCT_NAMES = %w[焼菓子 洋生菓子 半生菓子 生菓子 チョコレート 和菓子 キャンディ ビスケット].freeze
  EXPIRATION_DATES = [
    "製造日から7日",
    "製造日から14日",
    "製造日から30日",
    "製造日から60日",
    "製造日から90日",
    "製造日から180日",
    "製造日から1年"
  ].freeze
  STORAGE_METHODS = [
    "直射日光、高温多湿を避けて保存してください",
    "要冷蔵（10℃以下で保存してください）",
    "要冷凍（-18℃以下で保存してください）",
    "冷暗所で保存してください"
  ].freeze

  belongs_to :product

  validates :product_name, presence: true, inclusion: { in: PRODUCT_NAMES }
  validates :content_quantity, presence: true, length: { maximum: 255 }
  validates :expiration_date, presence: true, inclusion: { in: EXPIRATION_DATES }
  validates :storage_method, presence: true, inclusion: { in: STORAGE_METHODS }
  validates :manufacturer_name, presence: true, length: { maximum: 255 }
  validates :manufacturer_address, presence: true, length: { maximum: 255 }

  def ingredients_text
    ingredients = product.sorted_ingredient_names
    additives = product.sorted_additive_names
    allergens = product.allergen_label_names

    return "" if ingredients.empty? && additives.empty?

    text = ingredients.join("、")
    text += "／#{additives.join("、")}" if additives.any?
    text += "（一部に#{allergens.join("・")}を含む）" if allergens.any?
    text
  end

  def manufacturer_text
    [ manufacturer_name, manufacturer_address ].select(&:present?).join(" ")
  end
end
