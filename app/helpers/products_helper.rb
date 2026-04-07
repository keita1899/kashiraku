module ProductsHelper
  def material_select_options(materials)
    materials.map do |m|
      ["#{m.name}（#{m.unit} / #{m.unit_price}円）", m.id, m.select_option_data]
    end
  end
end
