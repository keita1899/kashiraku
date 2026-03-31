FactoryBot.define do
  factory :material do
    sequence(:name) { |n| "原材料#{n}" }
    purchase_price { 500 }
    purchase_quantity { 1000 }
    unit { "g" }
    additive { false }
    user

    trait :with_nutrition do
      energy { 349 }
      protein { 8.3 }
      fat { 1.5 }
      carbohydrate { 75.8 }
      salt { 0 }
    end
  end
end
