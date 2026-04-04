import { Controller } from "@hotwired/stimulus"

const PLACEHOLDER_TEXT = "（要入力）"
const PLACEHOLDER_CLASS = "text-gray-400"

export default class extends Controller {
  static targets = [
    "manufacturerName", "manufacturerAddress",
    "previewProductName", "previewContentQuantity", "previewExpirationDate",
    "previewStorageMethod", "previewManufacturer"
  ]

  update(event) {
    const cell = this[`${event.params.preview}Target`]
    this.updatePreviewCell(cell, event.target.value)
  }

  updateManufacturer() {
    const name = this.manufacturerNameTarget.value.trim()
    const address = this.manufacturerAddressTarget.value.trim()
    const text = [name, address].filter(Boolean).join(" ")
    this.updatePreviewCell(this.previewManufacturerTarget, text)
  }

  updatePreviewCell(cell, value) {
    cell.textContent = ""

    if (value) {
      cell.textContent = value
    } else {
      const span = document.createElement("span")
      span.className = PLACEHOLDER_CLASS
      span.textContent = PLACEHOLDER_TEXT
      cell.appendChild(span)
    }
  }
}
