require 'rails_helper'

RSpec.describe Allergen, type: :model do
  describe "バリデーション" do
    it "name, label_nameがあれば有効" do
      allergen = build(:allergen)
      expect(allergen).to be_valid
    end

    it "nameがなければ無効" do
      allergen = build(:allergen, name: nil)
      expect(allergen).to be_invalid
    end

    it "label_nameがなければ無効" do
      allergen = build(:allergen, label_name: nil)
      expect(allergen).to be_invalid
    end

    it "nameが重複していれば無効" do
      create(:allergen, name: "卵")
      allergen = build(:allergen, name: "卵")
      expect(allergen).to be_invalid
    end
  end
end
