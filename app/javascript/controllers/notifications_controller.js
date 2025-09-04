// app/javascript/controllers/notifications_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.boundNotify = this.notify.bind(this)
    window.addEventListener("notify", this.boundNotify)

    // Assert that container exists and has the correct position
    if (this.hasContainerTarget) {
      this.containerTarget.classList.add("fixed", "top-4", "right-4", "space-y-2", "z-50")
    } else {
      const container = document.createElement("div")
      container.dataset.notificationsTarget = "container"
      container.className = "fixed top-4 right-4 space-y-2 z-50"
      this.element.appendChild(container)
    }
  }

  disconnect() {
    window.removeEventListener("notify", this.boundNotify)
  }

  notify(event) {
    const { message, type } = event.detail || {}
    if (!message) return

    const toast = document.createElement("div")
    toast.className = `
      px-4 py-2 rounded-2xl shadow-lg text-white
      ${type === "alert" || type === "error" ? "bg-red-600" : "bg-green-600"}
    `
    toast.textContent = message

    this.containerTarget.appendChild(toast)

    setTimeout(() => {
      toast.classList.add("opacity-0", "transition", "duration-300")
      setTimeout(() => toast.remove(), 300)
    }, 2500)
  }
}
