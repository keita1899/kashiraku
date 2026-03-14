require 'rails_helper'

RSpec.describe "Materials", type: :request do
  let(:user) { create(:user, provider: "google_oauth2", uid: "123", email: "test@example.com") }
  let(:other_user) { create(:user, provider: "google_oauth2", uid: "456", email: "other@example.com") }
  let(:valid_params) do
    { material: { name: "薄力粉", purchase_price: 300, purchase_quantity: 1000, unit: "g", unit_price: 0.3 } }
  end

  describe "未ログイン時" do
    it "一覧にアクセスするとリダイレクトされる" do
      get materials_path
      expect(response).to redirect_to(root_path)
    end

    it "登録ページにアクセスするとリダイレクトされる" do
      get new_material_path
      expect(response).to redirect_to(root_path)
    end

    it "登録しようとするとリダイレクトされる" do
      post materials_path, params: valid_params
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /materials" do
    before { sign_in user }

    it "自分の原材料のみ表示される" do
      create(:material, user: user, name: "薄力粉")
      create(:material, user: other_user, name: "他人の材料")
      get materials_path

      expect(response.body).to include("薄力粉")
      expect(response.body).not_to include("他人の材料")
    end
  end

  describe "GET /materials/new" do
    before { sign_in user }

    it "登録フォームが表示される" do
      get new_material_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /materials" do
    before { sign_in user }

    it "有効なパラメータで原材料が作成される" do
      expect {
        post materials_path, params: valid_params
      }.to change(Material, :count).by(1)
      expect(response).to redirect_to(materials_path)
      expect(flash[:notice]).to eq("原材料を登録しました")
    end

    it "無効なパラメータではエラーが表示される" do
      expect {
        post materials_path, params: { material: { name: "" } }
      }.not_to change(Material, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
