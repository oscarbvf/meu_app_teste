import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    if (!this.hasContainerTarget) {
      const container = document.createElement("div")
      container.dataset.notificationsTarget = "container"
      container.className = "fixed top-4 right-4 space-y-2 z-50"
      this.element.appendChild(container)
    }
  }

  notify(event) {
    const { message, type } = event.detail

    const toast = document.createElement("div")
    toast.className = `
      px-4 py-2 rounded shadow-lg text-white animate-fade-in
      ${type === "error" ? "bg-red-600" : "bg-green-600"}
    `
    toast.innerText = message

    this.containerTarget.appendChild(toast)

    setTimeout(() => {
      toast.classList.add("opacity-0", "transition", "duration-500")
      setTimeout(() => toast.remove(), 500)
    }, 3000)
  }
}
