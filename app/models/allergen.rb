class Allergen < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :label_name, presence: true
end
