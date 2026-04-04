require 'rails_helper'

RSpec.describe FoodLabel, type: :model do
  describe "バリデーション" do
    it "すべての必須項目があれば有効" do
      food_label = build(:food_label)
      expect(food_label).to be_valid
    end

    it "product_nameがなければ無効" do
      food_label = build(:food_label, product_name: nil)
      expect(food_label).to be_invalid
    end

    it "product_nameが定数に含まれない値なら無効" do
      food_label = build(:food_label, product_name: "無効な名称")
      expect(food_label).to be_invalid
    end

    it "content_quantityがなければ無効" do
      food_label = build(:food_label, content_quantity: nil)
      expect(food_label).to be_invalid
    end

    it "expiration_dateがなければ無効" do
      food_label = build(:food_label, expiration_date: nil)
      expect(food_label).to be_invalid
    end

    it "expiration_dateが定数に含まれない値なら無効" do
      food_label = build(:food_label, expiration_date: "無効な期限")
      expect(food_label).to be_invalid
    end

    it "storage_methodがなければ無効" do
      food_label = build(:food_label, storage_method: nil)
      expect(food_label).to be_invalid
    end

    it "storage_methodが定数に含まれない値なら無効" do
      food_label = build(:food_label, storage_method: "無効な保存方法")
      expect(food_label).to be_invalid
    end

    it "manufacturer_nameがなければ無効" do
      food_label = build(:food_label, manufacturer_name: nil)
      expect(food_label).to be_invalid
    end

    it "manufacturer_addressがなければ無効" do
      food_label = build(:food_label, manufacturer_address: nil)
      expect(food_label).to be_invalid
    end
  end

  describe "#ingredients_text" do
    let(:product) { create(:product) }
    let(:food_label) { create(:food_label, product: product) }

    context "原材料がある場合" do
      it "重量順にカンマ区切りで返す" do
        flour = create(:material, user: product.user, name: "薄力粉", additive: false)
        sugar = create(:material, user: product.user, name: "砂糖", additive: false)
        create(:product_material, product: product, material: flour, quantity: 200)
        create(:product_material, product: product, material: sugar, quantity: 100)

        expect(food_label.ingredients_text).to eq("薄力粉、砂糖")
      end
    end

    context "添加物がある場合" do
      it "スラッシュ区切りで添加物を追加する" do
        flour = create(:material, user: product.user, name: "薄力粉", additive: false)
        vanilla = create(:material, user: product.user, name: "バニラ香料", additive: true)
        create(:product_material, product: product, material: flour, quantity: 200)
        create(:product_material, product: product, material: vanilla, quantity: 5)

        expect(food_label.ingredients_text).to eq("薄力粉／バニラ香料")
      end
    end

    context "アレルゲンがある場合" do
      it "括弧内にアレルゲンを表示する" do
        egg_allergen = create(:allergen, name: "鶏卵", label_name: "卵")
        flour = create(:material, user: product.user, name: "薄力粉", additive: false)
        flour.allergens << egg_allergen
        create(:product_material, product: product, material: flour, quantity: 200)

        expect(food_label.ingredients_text).to eq("薄力粉（一部に卵を含む）")
      end
    end

    context "原材料がない場合" do
      it "空文字を返す" do
        expect(food_label.ingredients_text).to eq("")
      end
    end
  end

  describe "#manufacturer_text" do
    it "製造者名と住所をスペース区切りで返す" do
      food_label = build(:food_label, manufacturer_name: "テスト製菓", manufacturer_address: "東京都渋谷区")
      expect(food_label.manufacturer_text).to eq("テスト製菓 東京都渋谷区")
    end

    it "住所が空の場合は製造者名のみ返す" do
      food_label = build(:food_label, manufacturer_name: "テスト製菓", manufacturer_address: "")
      expect(food_label.manufacturer_text).to eq("テスト製菓")
    end
  end
end
