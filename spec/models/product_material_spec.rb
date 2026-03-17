require 'rails_helper'

RSpec.describe ProductMaterial, type: :model do
  describe "バリデーション" do
    it "有効なデータであれば有効" do
      product_material = build(:product_material)
      expect(product_material).to be_valid
    end

    it "quantityがなければ無効" do
      product_material = build(:product_material, quantity: nil)
      expect(product_material).to be_invalid
    end

    it "quantityが0以下なら無効" do
      product_material = build(:product_material, quantity: 0)
      expect(product_material).to be_invalid
    end

    it "同じ商品に同じ原材料は重複できない" do
      product_material = create(:product_material)
      duplicate = build(:product_material, product: product_material.product, material: product_material.material)
      expect(duplicate).to be_invalid
    end
  end
end
