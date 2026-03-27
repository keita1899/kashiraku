import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "input", "submit"]
  static values = { keyword: String }

  disconnect() {
    document.body.style.overflow = ""
  }

  open() {
    this.modalTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.body.style.overflow = ""
    this.inputTarget.value = ""
    this.submitTarget.disabled = true
  }

  verify(event) {
    if (event.type === "keydown" && event.key === "Enter") {
      event.preventDefault()
      return
    }
    this.submitTarget.disabled = this.inputTarget.value !== this.keywordValue
  }

  backdropClose(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }

  closeOnEscape(event) {
    if (event.key === "Escape" && !this.modalTarget.classList.contains("hidden")) {
      this.close()
    }
  }
}
