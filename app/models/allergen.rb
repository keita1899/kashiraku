class Allergen < ApplicationRecord
  has_many :material_allergens, dependent: :destroy
  has_many :materials, through: :material_allergens

  validates :name, presence: true, uniqueness: true
  validates :label_name, presence: true

  scope :required_items, -> { where(required: true) }
  scope :recommended_items, -> { where(required: false) }
end
