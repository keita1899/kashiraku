import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "salesPrice", "row", "destroy", "materialSelect", "quantity", "subtotal",
    "summary", "salesPriceDisplay", "totalCost", "grossProfit", "costRate", "profitRate"
  ]

  connect() { this.recalculate() }
  rowTargetConnected() { this.recalculate() }
  rowTargetDisconnected() { this.recalculate() }

  recalculate() {
    const salesPrice = parseFloat(this.salesPriceTarget.value) || 0
    const subtotals = this.collectSubtotals()
    const summary = this.calculate(salesPrice, subtotals)
    this.display(summary, subtotals)
  }

  collectSubtotals() {
    return this.rowTargets.map((_, index) => {
      if (this.destroyTargets[index]?.value === "true") return 0

      const unitPrice = parseFloat(this.materialSelectTargets[index]?.selectedOptions[0]?.dataset.unitPrice) || 0
      const quantity = parseFloat(this.quantityTargets[index]?.value) || 0

      return Math.round(unitPrice * quantity)
    })
  }

  calculate(salesPrice, subtotals) {
    const totalCost = subtotals.reduce((sum, s) => sum + s, 0)
    const grossProfit = salesPrice - totalCost
    const costRate = salesPrice > 0 ? this.formatRate(totalCost / salesPrice * 100) : "0"
    const profitRate = salesPrice > 0 ? this.formatRate(grossProfit / salesPrice * 100) : "0"

    return { salesPrice, totalCost, grossProfit, costRate, profitRate }
  }

  formatRate(rate) {
    const rounded = Math.round(rate * 10) / 10
    return rounded % 1 === 0 ? String(rounded) : rounded.toFixed(1)
  }

  display({ salesPrice, totalCost, grossProfit, costRate, profitRate }, subtotals) {
    subtotals.forEach((subtotal, index) => {
      if (this.subtotalTargets[index]) {
        this.subtotalTargets[index].textContent = `${subtotal.toLocaleString()}円`
      }
    })

    if (!this.hasSummaryTarget) return

    this.salesPriceDisplayTarget.textContent = `${Math.round(salesPrice).toLocaleString()}円`
    this.totalCostTarget.textContent = `${totalCost.toLocaleString()}円`
    this.grossProfitTarget.textContent = `${grossProfit.toLocaleString()}円`
    this.costRateTarget.textContent = `${costRate}%`
    this.profitRateTarget.textContent = `${profitRate}%`
  }
}
