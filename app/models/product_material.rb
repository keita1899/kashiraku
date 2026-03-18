class ProductMaterial < ApplicationRecord
  belongs_to :product
  belongs_to :material

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :material_belongs_to_product_user

  private

  def material_belongs_to_product_user
    return if material.blank? || product.blank?

    errors.add(:material, "は自分の原材料を選択してください") if material.user_id != product.user_id
  end
end
