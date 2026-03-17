FactoryBot.define do
  factory :product_material do
    product
    material
    quantity { 100 }
  end
end
