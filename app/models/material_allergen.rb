class MaterialAllergen < ApplicationRecord
  belongs_to :material
  belongs_to :allergen

  validates :allergen_id, uniqueness: { scope: :material_id }
end
