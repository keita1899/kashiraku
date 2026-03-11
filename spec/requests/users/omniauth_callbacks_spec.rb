require "rails_helper"

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  let(:auth_hash) do
    OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "12345",
      info: { name: "テストユーザー", email: "test@example.com" }
    )
  end

  before do
    OmniAuth.config.mock_auth[:google_oauth2] = auth_hash
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  after do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
    Rails.application.env_config["omniauth.auth"] = nil
  end

  describe "Google認証成功" do
    it "新規ユーザーが作成されリダイレクトされる" do
      expect {
        get "/users/auth/google_oauth2/callback"
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end

    it "既存ユーザーの場合は新規作成されずリダイレクトされる" do
      User.create!(provider: "google_oauth2", uid: "12345", name: "テストユーザー", email: "test@example.com")

      expect {
        get "/users/auth/google_oauth2/callback"
      }.not_to change(User, :count)

      expect(response).to redirect_to(root_path)
    end
  end

  describe "Google認証失敗" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
      Rails.application.env_config["omniauth.auth"] = nil
    end

    it "rootにリダイレクトされエラーメッセージが設定される" do
      get "/users/auth/google_oauth2/callback"

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("ログインに失敗しました")
    end
  end
end
