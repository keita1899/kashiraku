require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "バリデーション" do
    it "すべての必須項目があれば有効" do
      product = build(:product)
      expect(product).to be_valid
    end

    it "nameがなければ無効" do
      product = build(:product, name: nil)
      expect(product).to be_invalid
    end

    it "categoryがなければ無効" do
      product = build(:product, category: nil)
      expect(product).to be_invalid
    end

    it "categoryが定数に含まれない値なら無効" do
      product = build(:product, category: "無効なカテゴリ")
      expect(product).to be_invalid
    end

    it "sales_priceがなければ無効" do
      product = build(:product, sales_price: nil)
      expect(product).to be_invalid
    end

    it "sales_priceが0以下なら無効" do
      product = build(:product, sales_price: 0)
      expect(product).to be_invalid
    end

    it "sales_priceが負なら無効" do
      product = build(:product, sales_price: -100)
      expect(product).to be_invalid
    end
  end

  describe "アソシエーション" do
    it "ユーザーが削除されると商品も削除される" do
      product = create(:product)
      user = product.user
      expect { user.destroy }.to change(described_class, :count).by(-1)
    end

    it "原材料を紐づけられる" do
      product = create(:product)
      material = create(:material, user: product.user)
      create(:product_material, product: product, material: material, quantity: 100)
      expect(product.materials).to include(material)
    end

    it "商品を削除すると中間テーブルも削除される" do
      product_material = create(:product_material)
      product = product_material.product
      expect { product.destroy }.to change(ProductMaterial, :count).by(-1)
    end
  end
end
