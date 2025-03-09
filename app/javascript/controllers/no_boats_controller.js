import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["checkbox", "submit", "container", "add"]

    connect() {
        this.checkFields()
    }

    checkFields() {
        if (this.checkboxTarget.checked) {
            this.containerTarget.classList.add("hidden")
            this.addTarget.classList.add("hidden")
        } else {
            this.containerTarget.classList.remove("hidden")
            this.addTarget.classList.remove("hidden")
        }
    }

    update() {
        this.checkFields()
    }
}