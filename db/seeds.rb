# 特定原材料（表示義務）8品目
# 特定原材料に準ずるもの（表示推奨）20品目
allergens = [
  { name: "えび", label_name: "えび", required: true },
  { name: "かに", label_name: "かに", required: true },
  { name: "くるみ", label_name: "くるみ", required: true },
  { name: "小麦", label_name: "小麦", required: true },
  { name: "そば", label_name: "そば", required: true },
  { name: "卵", label_name: "卵", required: true },
  { name: "乳", label_name: "乳成分", required: true },
  { name: "落花生", label_name: "落花生", required: true },
  { name: "アーモンド", label_name: "アーモンド", required: false },
  { name: "あわび", label_name: "あわび", required: false },
  { name: "いか", label_name: "いか", required: false },
  { name: "いくら", label_name: "いくら", required: false },
  { name: "オレンジ", label_name: "オレンジ", required: false },
  { name: "カシューナッツ", label_name: "カシューナッツ", required: false },
  { name: "キウイフルーツ", label_name: "キウイフルーツ", required: false },
  { name: "牛肉", label_name: "牛肉", required: false },
  { name: "ごま", label_name: "ごま", required: false },
  { name: "さけ", label_name: "さけ", required: false },
  { name: "さば", label_name: "さば", required: false },
  { name: "大豆", label_name: "大豆", required: false },
  { name: "鶏肉", label_name: "鶏肉", required: false },
  { name: "バナナ", label_name: "バナナ", required: false },
  { name: "豚肉", label_name: "豚肉", required: false },
  { name: "マカダミアナッツ", label_name: "マカダミアナッツ", required: false },
  { name: "もも", label_name: "もも", required: false },
  { name: "やまいも", label_name: "やまいも", required: false },
  { name: "りんご", label_name: "りんご", required: false },
  { name: "ゼラチン", label_name: "ゼラチン", required: false }
]

allergens.each do |attrs|
  Allergen.find_or_create_by!(name: attrs[:name]) do |allergen|
    allergen.label_name = attrs[:label_name]
    allergen.required = attrs[:required]
  end
end
