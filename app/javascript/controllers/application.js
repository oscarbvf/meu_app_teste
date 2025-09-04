import { Application } from "@hotwired/stimulus"
import "controllers"
import "custom_actions/notify"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
