// app/javascript/custom_actions/notify.js
// Register a 'notify' action for <turbo-stream action="notify" ...>
// Uses window.Turbo (loaded by "@hotwired/turbo-rails")
(function () {
  // Wait for Turbo available
  const register = () => {
    if (!window.Turbo) {
      // If not loaded, try again on 50ms
      return setTimeout(register, 50)
    }

    if (!window.Turbo.StreamActions) {
      console.warn("Turbo.StreamActions não disponível")
      return
    }

    // Register 'notify' action
    window.Turbo.StreamActions.notify = function () {
      const message = this.getAttribute("message")
      const type = this.getAttribute("type") || "notice"
      const event = new CustomEvent("notify", { detail: { message, type } })
      window.dispatchEvent(event)
    }
  }

  register()
})()
