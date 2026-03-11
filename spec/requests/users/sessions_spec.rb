require "rails_helper"

RSpec.describe "Users::Sessions", type: :request do
  describe "DELETE /users/sign_out" do
    context "ログイン状態の場合" do
      let(:user) { User.create!(provider: "google_oauth2", uid: "12345", name: "テスト", email: "test@example.com") }

      before { sign_in user }

      it "ログアウトされrootにリダイレクトされる" do
        delete destroy_user_session_path

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("ログアウトしました")
      end
    end

    context "未ログイン状態の場合" do
      it "rootにリダイレクトされる" do
        delete destroy_user_session_path

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
