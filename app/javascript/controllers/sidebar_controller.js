import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "menu"]
  connect() {
    // this.element.textContent = "Sidebar!"
  }

  toggle() {
    this.menuTarget.classList.toggle('sr-only')
    // this.menuTarget.classList.toggle('md:-translate-x-full')
  }
}
