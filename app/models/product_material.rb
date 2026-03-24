class ProductMaterial < ApplicationRecord
  belongs_to :product
  belongs_to :material

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :material_belongs_to_product_user

  def subtotal
    return 0 if material.blank? || quantity.blank?

    quantity * material.unit_price
  end

  private

  def material_belongs_to_product_user
    return if material.blank? || product.blank?

    errors.add(:material, "は自分の原材料を選択してください") if material.user_id != product.user_id
  end
end
