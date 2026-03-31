module CostCalculatable
  extend ActiveSupport::Concern

  def total_cost
    product_materials.sum(&:subtotal)
  end

  def cost_rate
    return 0 if sales_price.blank? || sales_price.zero?

    rate = (total_cost / sales_price * 100).round(1)
    rate % 1 == 0 ? rate.to_i : rate
  end

  def gross_profit
    return 0 if sales_price.blank?

    sales_price - total_cost
  end

  def profit_rate
    return 0 if sales_price.blank? || sales_price.zero?

    rate = (gross_profit / sales_price * 100).round(1)
    rate % 1 == 0 ? rate.to_i : rate
  end
end
