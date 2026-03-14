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

  describe "アソシエーション" do
    it "ユーザーが削除されると原材料も削除される" do
      material = create(:material)
      user = material.user
      expect { user.destroy }.to change(described_class, :count).by(-1)
    end
  end
end
