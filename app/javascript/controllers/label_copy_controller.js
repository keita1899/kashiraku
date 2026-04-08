import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "button", "message"]

  buildLabelText() {
    const tables = this.contentTarget.querySelectorAll("table")
    const lines = []

    tables.forEach((table) => {
      const header = table.querySelector("thead th")
      if (header) {
        if (lines.length > 0) lines.push("")
        lines.push(header.textContent.trim())
      }

      table.querySelectorAll("tbody tr").forEach((row) => {
        const cells = row.querySelectorAll("th, td")
        if (cells.length === 2) {
          const label = cells[0].textContent.trim()
          const value = cells[1].textContent.trim()
          if (value && value !== "（要入力）" && value !== "-") {
            lines.push(`${label}\t${value}`)
          }
        }
      })
    })

    return lines.join("\n")
  }

  async copy() {
    if (!navigator.clipboard) {
      alert("コピーに失敗しました。手動でコピーしてください。")
      return
    }

    try {
      await navigator.clipboard.writeText(this.buildLabelText())
      this.showCopySuccess()
    } catch {
      alert("コピーに失敗しました。手動でコピーしてください。")
    }
  }

  showCopySuccess() {
    clearTimeout(this.timeout)
    this.messageTarget.classList.remove("hidden")
    this.buttonTarget.classList.add("text-orange-500")

    this.timeout = setTimeout(() => {
      this.messageTarget.classList.add("hidden")
      this.buttonTarget.classList.remove("text-orange-500")
    }, 2000)
  }
}
