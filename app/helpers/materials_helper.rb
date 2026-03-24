module MaterialsHelper
  def formatted_unit_price(material)
    return "---" if material.unit_price.blank?

    number_to_currency(material.unit_price, unit: "¥", precision: 2, format: "%u%n")
  end
end
