FactoryBot.define do
  factory :allergen do
    sequence(:name) { |n| "アレルゲン#{n}" }
    sequence(:label_name) { |n| "アレルゲン表示#{n}" }
    required { false }
  end
end
