FactoryBot.define do
  factory :food_label do
    product
    product_name { "焼菓子" }
    content_quantity { "1個" }
    expiration_date { "製造日から30日" }
    storage_method { "直射日光、高温多湿を避けて保存してください" }
    manufacturer_name { "テスト製菓" }
    manufacturer_address { "東京都渋谷区1-1-1" }
  end
end
