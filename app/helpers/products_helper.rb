module ProductsHelper
  def material_select_options(materials)
    materials.map do |m|
      label = "#{m.name}（#{m.unit} / #{m.unit_price}円）"
      data = {
        "data-unit-price" => m.unit_price.to_f,
        "data-allergens" => m.allergens.map { |a| { name: a.name, required: a.required? } }.to_json,
        "data-energy" => m.energy&.to_f || "",
        "data-protein" => m.protein&.to_f || "",
        "data-fat" => m.fat&.to_f || "",
        "data-carbohydrate" => m.carbohydrate&.to_f || "",
        "data-salt" => m.salt&.to_f || ""
      }
      [ label, m.id, data ]
    end
  end
end
