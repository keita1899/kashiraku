module NutritionCalculatable
  extend ActiveSupport::Concern

  NUTRITION_SCALE = 2
  NUTRITION_FIELDS = %i[energy protein fat carbohydrate salt].freeze

  # g と ml を区別せず合算（栄養成分表示は推定値のため許容）
  def total_weight
    product_materials.sum { |pm| pm.quantity || 0 }
  end

  def total_energy
    nutrition_totals[:energy]
  end

  def total_protein
    nutrition_totals[:protein]
  end

  def total_fat
    nutrition_totals[:fat]
  end

  def total_carbohydrate
    nutrition_totals[:carbohydrate]
  end

  def total_salt
    nutrition_totals[:salt]
  end

  def has_nutrition_data?
    NUTRITION_FIELDS.any? { |f| nutrition_totals[f].positive? }
  end

  def nutrition_per_100g(field)
    raise ArgumentError, "Invalid nutrition field: #{field}" unless NUTRITION_FIELDS.include?(field)

    total = nutrition_totals[field]
    weight = total_weight
    return 0 if weight.zero?

    (total * 100 / weight).round(1)
  end

  private

  def nutrition_totals
    @nutrition_totals ||= begin
      result = NUTRITION_FIELDS.each_with_object({}) { |f, h| h[f] = 0.0 }
      product_materials.each do |pm|
        next if pm.material.blank? || pm.quantity.blank?

        NUTRITION_FIELDS.each do |field|
          value = pm.material.public_send(field)
          next if value.nil?

          result[field] += value * pm.quantity / 100
        end
      end
      result.transform_values { |v| v.round(NUTRITION_SCALE) }
    end
  end
end
