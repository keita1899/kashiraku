import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["price", "quantity", "unitPrice"]

  calculate() {
    const price = parseFloat(this.priceTarget.value)
    const quantity = parseFloat(this.quantityTarget.value)

    if (price > 0 && quantity > 0) {
      const unitPrice = (price / quantity).toFixed(2)
      this.unitPriceTarget.textContent = `¥${unitPrice}`
    } else {
      this.unitPriceTarget.textContent = "---"
    }
  }
}
