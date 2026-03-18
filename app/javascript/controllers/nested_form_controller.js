import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]

  add() {
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    const row = event.target.closest(".nested-fields")
    const idInput = row.querySelector("input[name*='[id]']")

    if (idInput) {
      row.querySelector("input[name*='_destroy']").value = "true"
      row.style.display = "none"
    } else {
      row.remove()
    }
  }
}
