require 'rails_helper'

RSpec.describe User, type: :model do
  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "12345",
        info: { name: "テストユーザー", email: "test@example.com" }
      )
    end

    context "新規ユーザーの場合" do
      it "ユーザーが作成される" do
        expect { described_class.from_omniauth(auth) }
          .to change(described_class, :count).by(1)
      end
    end

    context "既存ユーザーの場合" do
      before { described_class.from_omniauth(auth) }

      it "新規作成されない" do
        expect { described_class.from_omniauth(auth) }
          .not_to change(described_class, :count)
      end
    end

    context "既存ユーザーが名前を変更した場合" do
      before { described_class.from_omniauth(auth) }

      it "名前が更新される" do
        auth.info.name = "新しい名前"
        user = described_class.from_omniauth(auth)
        expect(user.name).to eq("新しい名前")
      end
    end
  end
end
