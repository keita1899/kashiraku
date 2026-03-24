require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:user) { create(:user, provider: "google_oauth2", uid: "123", email: "test@example.com") }
  let(:other_user) { create(:user, provider: "google_oauth2", uid: "456", email: "other@example.com") }
  let(:valid_params) do
    { product: { name: "マドレーヌ", category: "焼き菓子", sales_price: 350 } }
  end

  describe "未ログイン時" do
    it "一覧にアクセスするとリダイレクトされる" do
      get products_path
      expect(response).to redirect_to(root_path)
    end

    it "登録ページにアクセスするとリダイレクトされる" do
      get new_product_path
      expect(response).to redirect_to(root_path)
    end

    it "登録しようとするとリダイレクトされる" do
      post products_path, params: valid_params
      expect(response).to redirect_to(root_path)
    end

    it "編集ページにアクセスするとリダイレクトされる" do
      product = create(:product, user: user)
      get edit_product_path(product)
      expect(response).to redirect_to(root_path)
    end

    it "更新しようとするとリダイレクトされる" do
      product = create(:product, user: user)
      patch product_path(product), params: valid_params
      expect(response).to redirect_to(root_path)
    end

    it "削除しようとするとリダイレクトされる" do
      product = create(:product, user: user)
      delete product_path(product)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /products" do
    before { sign_in user }

    it "一覧が表示される" do
      get products_path
      expect(response).to have_http_status(:ok)
    end

    it "自分の商品のみ表示される" do
      create(:product, user: user, name: "マドレーヌ")
      create(:product, user: other_user, name: "他人の商品")
      get products_path

      expect(response.body).to include("マドレーヌ")
      expect(response.body).not_to include("他人の商品")
    end

    it "原価率が表示される" do
      material = create(:material, user: user, purchase_price: 500, purchase_quantity: 1000)
      product = create(:product, user: user, sales_price: 350)
      create(:product_material, product: product, material: material, quantity: 100)
      get products_path

      expect(response.body).to include("14.3%")
    end
  end

  describe "GET /products/new" do
    before { sign_in user }

    it "登録フォームが表示される" do
      get new_product_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /products" do
    before { sign_in user }

    it "有効なパラメータで商品が作成される" do
      expect {
        post products_path, params: valid_params
      }.to change(Product, :count).by(1)
      expect(response).to redirect_to(products_path)
      expect(flash[:notice]).to eq("商品を登録しました")
    end

    it "無効なパラメータではエラーが表示される" do
      expect {
        post products_path, params: { product: { name: "" } }
      }.not_to change(Product, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "原材料と一緒に商品が作成される" do
      material = create(:material, user: user)
      nested = { product_materials_attributes: { "0" => { material_id: material.id, quantity: 50 } } }
      expect {
        post products_path, params: { product: valid_params[:product].merge(nested) }
      }.to change(Product, :count).by(1).and change(ProductMaterial, :count).by(1)
    end

    it "他ユーザーの原材料では商品を作成できない" do
      other_material = create(:material, user: other_user)
      nested = { product_materials_attributes: { "0" => { material_id: other_material.id, quantity: 50 } } }
      expect {
        post products_path, params: { product: valid_params[:product].merge(nested) }
      }.not_to change(Product, :count)
      expect(ProductMaterial.count).to eq(0)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /products/:id/edit" do
    before { sign_in user }

    it "自分の商品の編集フォームが表示される" do
      product = create(:product, user: user)
      get edit_product_path(product)
      expect(response).to have_http_status(:ok)
    end

    it "他人の商品にはアクセスできない" do
      product = create(:product, user: other_user)
      get edit_product_path(product)
      expect(response).to have_http_status(:not_found)
    end

    it "原価情報が表示される" do
      material = create(:material, user: user, purchase_price: 500, purchase_quantity: 1000)
      product = create(:product, user: user, sales_price: 350)
      create(:product_material, product: product, material: material, quantity: 100)
      get edit_product_path(product)

      expect(response.body).to include("販売価格")
      expect(response.body).to include("材料費合計")
      expect(response.body).to include("原価率")
      expect(response.body).to include("粗利")
      expect(response.body).to include("利益率")
    end

    it "原材料がなくても原価情報が表示される" do
      product = create(:product, user: user)
      get edit_product_path(product)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("材料費合計")
    end
  end

  describe "PATCH /products/:id" do
    before { sign_in user }

    it "有効なパラメータで商品が更新される" do
      product = create(:product, user: user)
      patch product_path(product), params: { product: { name: "フィナンシェ" } }
      expect(response).to redirect_to(products_path)
      expect(product.reload.name).to eq("フィナンシェ")
    end

    it "無効なパラメータではエラーが表示される" do
      product = create(:product, user: user)
      patch product_path(product), params: { product: { name: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "他人の商品は更新できない" do
      product = create(:product, user: other_user)
      patch product_path(product), params: { product: { name: "フィナンシェ" } }
      expect(response).to have_http_status(:not_found)
    end

    it "原材料を追加できる" do
      product = create(:product, user: user)
      nested = { product_materials_attributes: { "0" => { material_id: create(:material, user: user).id, quantity: 30 } } }
      expect {
        patch product_path(product), params: { product: nested }
      }.to change(ProductMaterial, :count).by(1)
    end

    it "原材料を削除できる" do
      pm = create(:product_material, product: create(:product, user: user), material: create(:material, user: user))
      attrs = { product_materials_attributes: { "0" => { id: pm.id, _destroy: true } } }
      expect {
        patch product_path(pm.product), params: { product: attrs }
      }.to change(ProductMaterial, :count).by(-1)
    end

    it "他ユーザーの原材料は紐付けできない" do
      product = create(:product, user: user)
      other_material = create(:material, user: other_user)
      nested = { product_materials_attributes: { "0" => { material_id: other_material.id, quantity: 30 } } }
      expect {
        patch product_path(product), params: { product: nested }
      }.not_to change(ProductMaterial, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /products/:id" do
    before { sign_in user }

    it "自分の商品を削除できる" do
      product = create(:product, user: user)
      expect {
        delete product_path(product)
      }.to change(Product, :count).by(-1)
      expect(response).to redirect_to(products_path)
    end

    it "他人の商品は削除できない" do
      product = create(:product, user: other_user)
      expect {
        delete product_path(product)
      }.not_to change(Product, :count)
      expect(response).to have_http_status(:not_found)
    end
  end
end
