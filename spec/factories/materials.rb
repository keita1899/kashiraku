FactoryBot.define do
  factory :material do
    sequence(:name) { |n| "原材料#{n}" }
    purchase_price { 500 }
    purchase_quantity { 1000 }
    unit { "g" }
    unit_price { 0.5 }
    additive { false }
    user
  end
end
