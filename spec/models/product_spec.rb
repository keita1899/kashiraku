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

  describe "原価計算" do
    let(:product) { create(:product, sales_price: 500) }
    let(:material_a) { create(:material, user: product.user, purchase_price: 1000, purchase_quantity: 500, unit: "g") }
    let(:material_b) { create(:material, user: product.user, purchase_price: 300, purchase_quantity: 1000, unit: "ml") }

    before do
      create(:product_material, product: product, material: material_a, quantity: 200)
      create(:product_material, product: product, material: material_b, quantity: 100)
    end

    # material_a: unit_price = 1000/500 = 2.0, cost = 2.0 * 200 = 400
    # material_b: unit_price = 300/1000 = 0.3, cost = 0.3 * 100 = 30
    # total_cost = 430

    it "材料費合計を計算できる" do
      expect(product.total_cost).to eq(430)
    end

    it "原価率を計算できる" do
      expect(product.cost_rate).to eq(86.0)
    end

    it "粗利を計算できる" do
      expect(product.gross_profit).to eq(70)
    end

    it "利益率を計算できる" do
      expect(product.profit_rate).to eq(14.0)
    end

    context "sales_priceがnilの場合" do
      let(:nil_price_product) { build(:product, sales_price: nil) }

      it "原価率が0になる" do
        expect(nil_price_product.cost_rate).to eq(0)
      end

      it "粗利が0になる" do
        expect(nil_price_product.gross_profit).to eq(0)
      end

      it "利益率が0になる" do
        expect(nil_price_product.profit_rate).to eq(0)
      end
    end

    context "原材料が0件の場合" do
      let(:empty_product) { create(:product, sales_price: 500) }

      it "材料費合計が0になる" do
        expect(empty_product.total_cost).to eq(0)
      end

      it "原価率が0になる" do
        expect(empty_product.cost_rate).to eq(0)
      end

      it "粗利が販売価格と同じになる" do
        expect(empty_product.gross_profit).to eq(500)
      end
    end
  end
end
