FactoryBot.define do
  factory :product do
    name { "マドレーヌ" }
    category { "焼き菓子" }
    sales_price { 350 }
    user
  end
end
