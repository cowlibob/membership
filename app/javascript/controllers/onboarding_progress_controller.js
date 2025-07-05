import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["timeline"]
  static values = { 
    pollUrl: String,
    onboardingId: Number,
    interval: { type: Number, default: 30000 }
  }

  connect() {
    // Only start polling if we have valid poll URL and onboarding ID
    // This ensures we don't poll on the new page before onboarding begins
    if (this.hasValidPollingData()) {
      this.startPolling()
    }
  }

  hasValidPollingData() {
    return this.pollUrlValue && this.pollUrlValue !== '' && 
           this.onboardingIdValue && this.onboardingIdValue !== ''
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    if (this.hasValidPollingData()) {
      this.pollTimer = setInterval(() => {
        this.poll()
      }, this.intervalValue)
    }
  }

  stopPolling() {
    if (this.pollTimer) {
      clearInterval(this.pollTimer)
      this.pollTimer = null
    }
  }

  async poll() {
    try {
      const response = await fetch(this.pollUrlValue, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html"
        }
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
        
        // Check if onboarding is complete - stop polling if so
        const completedSteps = this.timelineTarget.querySelectorAll('[data-step-complete="true"]').length
        const totalSteps = this.timelineTarget.querySelectorAll('[data-step]').length
        
        if (completedSteps === totalSteps) {
          this.stopPolling()
          console.log("Onboarding complete, stopped polling")
        }
      }
    } catch (error) {
      console.error("Polling error:", error)
      // Continue polling even on error, but log it
    }
  }

  // Manual refresh triggered by user
  refresh() {
    this.poll()
  }
}