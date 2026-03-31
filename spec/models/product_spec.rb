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

  describe "アレルゲン集約" do
    let(:product) { create(:product) }
    let(:egg) { create(:allergen, :required, name: "卵") }
    let(:milk) { create(:allergen, :required, name: "乳") }
    let(:orange) { create(:allergen, name: "オレンジ") }

    before do
      material_a = create(:material, user: product.user)
      material_a.allergens << [ egg, milk ]
      material_b = create(:material, user: product.user)
      material_b.allergens << [ milk, orange ]
      create(:product_material, product: product, material: material_a, quantity: 100)
      create(:product_material, product: product, material: material_b, quantity: 50)
    end

    it "紐づく原材料のアレルゲンを重複なしで取得できる" do
      expect(product.allergens).to contain_exactly(egg, milk, orange)
    end

    it "特定原材料のみ取得できる" do
      expect(product.required_allergens).to contain_exactly(egg, milk)
    end

    it "推奨品目のみ取得できる" do
      expect(product.recommended_allergens).to contain_exactly(orange)
    end

    it "特定原材料が推奨品目より先に並ぶ" do
      allergens = product.allergens.to_a
      required_index = allergens.index(egg)
      recommended_index = allergens.index(orange)
      expect(required_index).to be < recommended_index
    end

    context "原材料が0件の場合" do
      let(:empty_product) { create(:product) }

      it "空の結果を返す" do
        expect(empty_product.allergens).to be_empty
      end
    end

    context "原材料がアレルゲンを持たない場合" do
      let(:no_allergen_product) { create(:product) }

      before do
        material = create(:material, user: no_allergen_product.user)
        create(:product_material, product: no_allergen_product, material: material, quantity: 100)
      end

      it "空の結果を返す" do
        expect(no_allergen_product.allergens).to be_empty
      end
    end
  end

  describe "栄養成分計算" do
    let(:product) { create(:product, sales_price: 500) }
    let(:material_a) do
      create(:material, :with_nutrition, user: product.user,
        purchase_price: 1000, purchase_quantity: 500, unit: "g",
        energy: 349, protein: 8.3, fat: 1.5, carbohydrate: 75.8, salt: 0)
    end
    let(:material_b) do
      create(:material, :with_nutrition, user: product.user,
        purchase_price: 300, purchase_quantity: 1000, unit: "g",
        energy: 720, protein: 0.5, fat: 81.0, carbohydrate: 0.2, salt: 1.9)
    end

    before do
      create(:product_material, product: product, material: material_a, quantity: 200)
      create(:product_material, product: product, material: material_b, quantity: 100)
    end

    it "エネルギー合計を計算できる" do
      # 349*200/100 + 720*100/100 = 698 + 720 = 1418
      expect(product.total_energy).to eq(1418.0)
    end

    it "たんぱく質合計を計算できる" do
      # 8.3*200/100 + 0.5*100/100 = 16.6 + 0.5 = 17.1
      expect(product.total_protein).to eq(17.1)
    end

    it "脂質合計を計算できる" do
      # 1.5*200/100 + 81.0*100/100 = 3.0 + 81.0 = 84.0
      expect(product.total_fat).to eq(84.0)
    end

    it "炭水化物合計を計算できる" do
      # 75.8*200/100 + 0.2*100/100 = 151.6 + 0.2 = 151.8
      expect(product.total_carbohydrate).to eq(151.8)
    end

    it "食塩相当量合計を計算できる" do
      # 0*200/100 + 1.9*100/100 = 0 + 1.9 = 1.9
      expect(product.total_salt).to eq(1.9)
    end

    it "総重量を計算できる" do
      expect(product.total_weight).to eq(300)
    end

    it "100gあたりの栄養成分を計算できる" do
      # 1418*100/300 = 472.7
      expect(product.nutrition_per_100g(:energy)).to eq(472.7)
    end

    it "100gあたりの食塩相当量を計算できる" do
      # 1.9*100/300 = 0.6
      expect(product.nutrition_per_100g(:salt)).to eq(0.6)
    end

    it "不正なフィールド名でArgumentErrorが発生する" do
      expect { product.nutrition_per_100g(:invalid) }.to raise_error(ArgumentError)
    end

    it "栄養データがあればhas_nutrition_data?がtrueを返す" do
      expect(product.has_nutrition_data?).to be true
    end

    context "原材料が0件の場合" do
      let(:empty_product) { create(:product) }

      it "栄養成分合計が0になる" do
        expect(empty_product.total_energy).to eq(0)
      end

      it "100gあたりが0になる" do
        expect(empty_product.nutrition_per_100g(:energy)).to eq(0)
      end
    end

    context "原材料に栄養データがない場合" do
      let(:no_nutrition_product) { create(:product) }

      before do
        material = create(:material, user: no_nutrition_product.user)
        create(:product_material, product: no_nutrition_product, material: material, quantity: 100)
      end

      it "栄養成分合計が0になる" do
        expect(no_nutrition_product.total_energy).to eq(0)
      end

      it "has_nutrition_data?がfalseを返す" do
        expect(no_nutrition_product.has_nutrition_data?).to be false
      end
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
