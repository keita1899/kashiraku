FactoryBot.define do
  factory :allergen do
    sequence(:name) { |n| "アレルゲン#{n}" }
    sequence(:label_name) { |n| "アレルゲン表示#{n}" }
    required { false }

    trait :required do
      required { true }
    end
  end
end
