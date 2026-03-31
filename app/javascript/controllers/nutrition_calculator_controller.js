import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "row", "destroy", "materialSelect", "quantity",
    "summary",
    "energy", "protein", "fat", "carbohydrate", "salt",
    "energyPer100g", "proteinPer100g", "fatPer100g", "carbohydratePer100g", "saltPer100g",
    "perItemSection", "per100gSection", "toggleButton",
    "emptyMessage"
  ]

  connect() {
    this.displayMode = "perItem"
    this.recalculate()
  }

  rowTargetConnected() { this.recalculate() }
  rowTargetDisconnected() { this.recalculate() }

  recalculate() {
    const { totals, totalWeight, hasNutrition } = this.collectNutrition()
    this.display(totals, totalWeight, hasNutrition)
  }

  collectNutrition() {
    const fields = ["energy", "protein", "fat", "carbohydrate", "salt"]
    const totals = { energy: 0, protein: 0, fat: 0, carbohydrate: 0, salt: 0 }
    let totalWeight = 0
    let hasNutrition = false

    this.materialSelectTargets.forEach((select, index) => {
      if (this.destroyTargets[index]?.value === "true") return

      const option = select.selectedOptions[0]
      if (!option?.value) return

      const quantity = parseFloat(this.quantityTargets[index]?.value) || 0
      totalWeight += quantity

      fields.forEach(field => {
        const raw = option.dataset[field]
        if (raw === "") return
        const value = parseFloat(raw) || 0
        hasNutrition = true
        totals[field] += value * quantity / 100
      })
    })

    return { totals, totalWeight, hasNutrition }
  }

  display(totals, totalWeight, hasNutrition) {
    if (!this.hasSummaryTarget) return

    this.energyTarget.textContent = this.formatValue(totals.energy, "kcal")
    this.proteinTarget.textContent = this.formatValue(totals.protein, "g")
    this.fatTarget.textContent = this.formatValue(totals.fat, "g")
    this.carbohydrateTarget.textContent = this.formatValue(totals.carbohydrate, "g")
    this.saltTarget.textContent = this.formatValue(totals.salt, "g")

    if (totalWeight > 0) {
      this.energyPer100gTarget.textContent = this.formatValue(totals.energy * 100 / totalWeight, "kcal")
      this.proteinPer100gTarget.textContent = this.formatValue(totals.protein * 100 / totalWeight, "g")
      this.fatPer100gTarget.textContent = this.formatValue(totals.fat * 100 / totalWeight, "g")
      this.carbohydratePer100gTarget.textContent = this.formatValue(totals.carbohydrate * 100 / totalWeight, "g")
      this.saltPer100gTarget.textContent = this.formatValue(totals.salt * 100 / totalWeight, "g")
    } else {
      const fields = ["energyPer100g", "proteinPer100g", "fatPer100g", "carbohydratePer100g", "saltPer100g"]
      fields.forEach(f => { this[`${f}Target`].textContent = "-" })
    }

    this.summaryTarget.classList.toggle("hidden", !hasNutrition)
    if (this.hasEmptyMessageTarget) {
      this.emptyMessageTarget.classList.toggle("hidden", hasNutrition)
    }
  }

  toggleDisplay() {
    this.displayMode = this.displayMode === "perItem" ? "per100g" : "perItem"
    this.perItemSectionTarget.classList.toggle("hidden", this.displayMode !== "perItem")
    this.per100gSectionTarget.classList.toggle("hidden", this.displayMode !== "per100g")
    this.toggleButtonTarget.textContent =
      this.displayMode === "perItem" ? "100gあたりに切替" : "1個あたりに切替"
  }

  formatValue(value, unit) {
    const rounded = Math.round(value * 10) / 10
    return `${rounded.toFixed(1)}${unit}`
  }
}
