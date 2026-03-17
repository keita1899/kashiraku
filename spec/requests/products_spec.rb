require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:user) { create(:user, provider: "google_oauth2", uid: "123", email: "test@example.com") }
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
  end

  describe "GET /products" do
    before { sign_in user }

    it "一覧が表示される" do
      get products_path
      expect(response).to have_http_status(:ok)
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
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
