require 'rails_helper'

RSpec.describe "Materials", type: :request do
  let(:user) { create(:user, provider: "google_oauth2", uid: "123", email: "test@example.com") }
  let(:other_user) { create(:user, provider: "google_oauth2", uid: "456", email: "other@example.com") }
  let(:valid_params) do
    { material: { name: "薄力粉", purchase_price: 300, purchase_quantity: 1000, unit: "g" } }
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

    it "編集ページにアクセスするとリダイレクトされる" do
      material = create(:material, user: user)
      get edit_material_path(material)
      expect(response).to redirect_to(root_path)
    end

    it "更新しようとするとリダイレクトされる" do
      material = create(:material, user: user)
      patch material_path(material), params: valid_params
      expect(response).to redirect_to(root_path)
    end

    it "削除しようとするとリダイレクトされる" do
      material = create(:material, user: user)
      delete material_path(material)
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

    it "アレルゲンを紐づけて登録できる" do
      allergen = create(:allergen)
      params = valid_params.deep_merge(material: { allergen_ids: [ allergen.id ] })
      post materials_path, params: params
      expect(Material.last.allergens).to include(allergen)
    end

    it "無効なパラメータではエラーが表示される" do
      expect {
        post materials_path, params: { material: { name: "" } }
      }.not_to change(Material, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /materials/:id/edit" do
    before { sign_in user }

    it "自分の原材料の編集フォームが表示される" do
      material = create(:material, user: user)
      get edit_material_path(material)
      expect(response).to have_http_status(:ok)
    end

    it "他人の原材料にはアクセスできない" do
      material = create(:material, user: other_user)
      get edit_material_path(material)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /materials/:id" do
    before { sign_in user }

    it "有効なパラメータで原材料が更新される" do
      material = create(:material, user: user)
      patch material_path(material), params: { material: { name: "強力粉" } }
      expect(response).to redirect_to(materials_path)
      expect(material.reload.name).to eq("強力粉")
    end

    it "無効なパラメータではエラーが表示される" do
      material = create(:material, user: user)
      patch material_path(material), params: { material: { name: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "アレルゲンを更新できる" do
      material = create(:material, user: user)
      allergen = create(:allergen)
      patch material_path(material), params: { material: { allergen_ids: [ allergen.id ] } }
      expect(material.reload.allergens).to include(allergen)
    end

    it "アレルゲンを全て外せる" do
      allergen = create(:allergen)
      material = create(:material, user: user)
      material.allergens << allergen
      patch material_path(material), params: { material: { allergen_ids: [ "" ] } }
      expect(material.reload.allergens).to be_empty
    end

    it "他人の原材料は更新できない" do
      material = create(:material, user: other_user)
      patch material_path(material), params: { material: { name: "強力粉" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /materials/:id" do
    before { sign_in user }

    it "自分の原材料を削除できる" do
      material = create(:material, user: user)
      expect {
        delete material_path(material)
      }.to change(Material, :count).by(-1)
      expect(response).to redirect_to(materials_path)
    end

    it "他人の原材料は削除できない" do
      material = create(:material, user: other_user)
      expect {
        delete material_path(material)
      }.not_to change(Material, :count)
      expect(response).to have_http_status(:not_found)
    end
  end
end
