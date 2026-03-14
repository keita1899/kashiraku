require 'rails_helper'

RSpec.describe Material, type: :model do
  describe "バリデーション" do
    it "すべての必須項目があれば有効" do
      material = build(:material)
      expect(material).to be_valid
    end

    it "nameがなければ無効" do
      material = build(:material, name: nil)
      expect(material).to be_invalid
    end

    it "purchase_priceがなければ無効" do
      material = build(:material, purchase_price: nil)
      expect(material).to be_invalid
    end

    it "purchase_priceが0以下なら無効" do
      material = build(:material, purchase_price: 0)
      expect(material).to be_invalid
    end

    it "purchase_priceが負なら無効" do
      material = build(:material, purchase_price: -100)
      expect(material).to be_invalid
    end

    it "purchase_quantityがなければ無効" do
      material = build(:material, purchase_quantity: nil)
      expect(material).to be_invalid
    end

    it "purchase_quantityが0以下なら無効" do
      material = build(:material, purchase_quantity: 0)
      expect(material).to be_invalid
    end

    it "purchase_quantityが負なら無効" do
      material = build(:material, purchase_quantity: -100)
      expect(material).to be_invalid
    end

    it "unitがなければ無効" do
      material = build(:material, unit: nil)
      expect(material).to be_invalid
    end

    it "unitがgとml以外なら無効" do
      material = build(:material, unit: "kg")
      expect(material).to be_invalid
    end
  end

  describe "単価の自動計算" do
    it "購入価格と購入量から単価が計算される" do
      material = build(:material, purchase_price: 500, purchase_quantity: 1000)
      material.valid?
      expect(material.unit_price).to eq(0.5)
    end

    it "購入量が0の場合は単価が0になる" do
      material = build(:material, purchase_price: 500, purchase_quantity: 0)
      material.valid?
      expect(material.unit_price).to eq(0)
    end

    it "購入価格がnilの場合は単価が0になる" do
      material = build(:material, purchase_price: nil, purchase_quantity: 1000)
      material.valid?
      expect(material.unit_price).to eq(0)
    end

    it "購入量がnilの場合は単価が0になる" do
      material = build(:material, purchase_price: 500, purchase_quantity: nil)
      material.valid?
      expect(material.unit_price).to eq(0)
    end

    it "更新時にも単価が再計算される" do
      material = create(:material, purchase_price: 500, purchase_quantity: 1000)
      material.update!(purchase_price: 1000)
      expect(material.unit_price).to eq(1.0)
    end

    it "小数が正しく計算される" do
      material = build(:material, purchase_price: 400, purchase_quantity: 450)
      material.valid?
      expect(material.unit_price).to eq(BigDecimal("0.8889"))
    end
  end

  describe "アソシエーション" do
    it "ユーザーが削除されると原材料も削除される" do
      material = create(:material)
      user = material.user
      expect { user.destroy }.to change(described_class, :count).by(-1)
    end
  end
end
