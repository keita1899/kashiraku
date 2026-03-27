require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  let(:user) { create(:user, provider: "google_oauth2", uid: "123", email: "test@example.com") }

  describe "DELETE /account" do
    context "ログイン時" do
      before { sign_in user }

      it "アカウントが削除される" do
        expect {
          delete account_path
        }.to change(User, :count).by(-1)
      end

      it "紐づく原材料が削除される" do
        create(:material, user: user)
        expect {
          delete account_path
        }.to change(Material, :count).by(-1)
      end

      it "紐づく商品が削除される" do
        create(:product, user: user)
        expect {
          delete account_path
        }.to change(Product, :count).by(-1)
      end

      it "紐づく商品原材料が削除される" do
        product = create(:product, user: user)
        material = create(:material, user: user)
        create(:product_material, product: product, material: material, quantity: 100)
        expect {
          delete account_path
        }.to change(ProductMaterial, :count).by(-1)
      end

      it "紐づく原材料アレルゲンが削除される" do
        material = create(:material, user: user)
        allergen = create(:allergen, :required, name: "卵")
        material.allergens << allergen
        expect {
          delete account_path
        }.to change(MaterialAllergen, :count).by(-1)
      end

      it "削除後にトップページにリダイレクトされる" do
        delete account_path
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("アカウントを削除しました")
      end
    end

    context "ゲストログイン時" do
      let(:guest) { create(:user, provider: "guest", uid: "guest_123", email: "guest@example.com") }

      before { sign_in guest }

      it "アカウントが削除されない" do
        expect {
          delete account_path
        }.not_to change(User, :count)
      end

      it "設定画面にリダイレクトされる" do
        delete account_path
        expect(response).to redirect_to(settings_path)
        expect(flash[:alert]).to eq("ゲストアカウントは削除できません")
      end
    end

    context "未ログイン時" do
      it "リダイレクトされる" do
        delete account_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
