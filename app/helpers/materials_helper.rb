module MaterialsHelper
  def formatted_unit_price(material)
    return "---" if material.unit_price.blank?

    number_to_currency(material.unit_price, unit: "円", precision: 2, format: "%n%u")
  end
end
