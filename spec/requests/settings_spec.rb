require 'rails_helper'

RSpec.describe "Settings", type: :request do
  let(:user) { create(:user, provider: "google_oauth2", uid: "123", email: "test@example.com") }

  describe "GET /settings" do
    context "ログイン時" do
      before { sign_in user }

      it "設定画面が表示される" do
        get settings_path
        expect(response).to have_http_status(:ok)
      end

      it "アカウント情報が表示される" do
        get settings_path
        expect(response.body).to include(user.email)
      end

      it "アカウント削除ボタンが表示される" do
        get settings_path
        expect(response.body).to include("アカウントを削除する")
      end
    end

    context "ゲストユーザーログイン時" do
      let(:guest) { create(:user, provider: "guest", uid: "guest_123") }

      before { sign_in guest }

      it "アカウント削除不可のメッセージが表示される" do
        get settings_path
        expect(response.body).to include("ゲストアカウントは削除できません")
      end
    end

    context "未ログイン時" do
      it "リダイレクトされる" do
        get settings_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /settings" do
    context "ログイン時" do
      before { sign_in user }

      it "製造者情報を更新できる" do
        patch settings_path, params: { user: { manufacturer_name: "テスト製菓", manufacturer_address: "東京都渋谷区1-1" } }
        expect(user.reload).to have_attributes(manufacturer_name: "テスト製菓", manufacturer_address: "東京都渋谷区1-1")
        expect(response).to redirect_to(settings_path)
      end

      it "更新成功時にフラッシュメッセージが表示される" do
        patch settings_path, params: { user: { manufacturer_name: "テスト製菓" } }
        expect(flash[:notice]).to eq("製造者情報を更新しました")
      end
    end

    context "未ログイン時" do
      it "リダイレクトされる" do
        patch settings_path, params: { user: { manufacturer_name: "テスト製菓" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
