require "rails_helper"

RSpec.describe "Users::GuestSessions", type: :request do
  describe "POST /users/guest_sign_in" do
    it "毎回新しいゲストユーザーが作成されログインできる" do
      expect {
        post guest_sign_in_path
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("ゲストとしてログインしました")
    end

    it "複数回ログインすると別々のゲストユーザーが作成される" do
      expect {
        2.times { post guest_sign_in_path }
      }.to change(User, :count).by(2)
    end
  end
end
