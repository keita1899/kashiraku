FactoryBot.define do
  factory :product_material do
    product
    material { association :material, user: product.user }
    quantity { 100 }
  end
end
