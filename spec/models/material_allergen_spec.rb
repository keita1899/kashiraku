require 'rails_helper'

RSpec.describe MaterialAllergen, type: :model do
  describe "バリデーション" do
    it "material_idとallergen_idがあれば有効" do
      material_allergen = build(:material_allergen)
      expect(material_allergen).to be_valid
    end

    it "同じ組み合わせは重複できない" do
      material_allergen = create(:material_allergen)
      duplicate = build(:material_allergen,
                        material: material_allergen.material,
                        allergen: material_allergen.allergen)
      expect(duplicate).to be_invalid
    end
  end
end
