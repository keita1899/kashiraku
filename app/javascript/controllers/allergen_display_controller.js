import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "row", "destroy", "materialSelect",
    "requiredSection", "requiredBadges", "recommendedSection", "recommendedBadges", "emptyMessage"
  ]

  connect() { this.updateAllergens() }
  rowTargetConnected() { this.updateAllergens() }
  rowTargetDisconnected() { this.updateAllergens() }

  updateAllergens() {
    const { required, recommended } = this.collectAllergens()

    this.requiredBadgesTarget.replaceChildren(...required.map(name => this.createBadge(name, "bg-red-50 text-red-600")))
    this.recommendedBadgesTarget.replaceChildren(...recommended.map(name => this.createBadge(name, "bg-yellow-50 text-yellow-700")))

    this.requiredSectionTarget.classList.toggle("hidden", required.length === 0)
    this.recommendedSectionTarget.classList.toggle("hidden", recommended.length === 0)
    this.emptyMessageTarget.classList.toggle("hidden", required.length > 0 || recommended.length > 0)
  }

  collectAllergens() {
    const allergenMap = new Map()

    this.materialSelectTargets.forEach((select, index) => {
      if (this.destroyTargets[index]?.value === "true") return

      const option = select.selectedOptions[0]
      if (!option?.dataset.allergens) return

      JSON.parse(option.dataset.allergens).forEach(({ name, required }) => {
        if (!allergenMap.has(name)) allergenMap.set(name, required)
      })
    })

    const required = []
    const recommended = []
    allergenMap.forEach((isRequired, name) => {
      (isRequired ? required : recommended).push(name)
    })

    return { required, recommended }
  }

  createBadge(name, colorClass) {
    const span = document.createElement("span")
    span.className = `text-xs px-1.5 py-0.5 rounded ${colorClass}`
    span.textContent = name
    return span
  }
}
