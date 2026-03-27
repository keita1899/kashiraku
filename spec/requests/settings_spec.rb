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

    context "未ログイン時" do
      it "リダイレクトされる" do
        get settings_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
