module ProductsHelper
  def material_select_options(materials)
    materials.map do |m|
      label = "#{m.name}（#{m.unit} / ¥#{m.unit_price}）"
      data = {
        "data-unit-price" => m.unit_price.to_f,
        "data-allergens" => m.allergens.map { |a| { name: a.name, required: a.required? } }.to_json
      }
      [label, m.id, data]
    end
  end
end
