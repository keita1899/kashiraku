require 'rails_helper'

RSpec.describe ProductMaterial, type: :model do
  describe "バリデーション" do
    it "有効なデータであれば有効" do
      product_material = build(:product_material)
      expect(product_material).to be_valid
    end

    it "quantityがなければ無効" do
      product_material = build(:product_material, quantity: nil)
      expect(product_material).to be_invalid
    end

    it "quantityが0以下なら無効" do
      product_material = build(:product_material, quantity: 0)
      expect(product_material).to be_invalid
    end

    it "他ユーザーの原材料は紐付けできない" do
      other_user = create(:user, provider: "google_oauth2", uid: "other", email: "other@example.com")
      product_material = build(:product_material, material: create(:material, user: other_user))
      expect(product_material).to be_invalid
    end
  end
end
