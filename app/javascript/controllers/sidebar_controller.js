import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "button", "menu" ]
  connect() {
    debugger
    // this.element.textContent = "Sidebar!"
  }

  toggle() {
    debugger
    this.menuTarget.classList.toggle('hidden')
  }
}
