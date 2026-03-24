class Product < ApplicationRecord
  CATEGORIES = %w[焼き菓子 生菓子 チョコレート パン 和菓子 アイス・冷菓 ドリンク その他].freeze

  belongs_to :user
  has_many :product_materials, dependent: :destroy
  has_many :materials, through: :product_materials
  accepts_nested_attributes_for :product_materials, allow_destroy: true

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :sales_price, presence: true, numericality: { greater_than: 0 }

  def total_cost
    product_materials.sum(&:subtotal)
  end

  def cost_rate
    return 0 if sales_price.blank? || sales_price.zero?

    rate = (total_cost / sales_price * 100).round(1)
    rate % 1 == 0 ? rate.to_i : rate
  end

  def gross_profit
    return 0 if sales_price.blank?

    sales_price - total_cost
  end
  
  def profit_rate
    return 0 if sales_price.blank? || sales_price.zero?

    rate = (gross_profit / sales_price * 100).round(1)
    rate % 1 == 0 ? rate.to_i : rate
  end
end
