import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["insured", "submit"]

    connect() {
        this.checkFields()
    }

    checkFields() {
        const allInsured = this.insuredTargets.every(target => {
            if (target.closest(".hidden")) {
                return true
            }
            if (target.type === "checkbox") {
                return target.checked
            } else if (target.tagName === "SELECT") {
                return target.value === "true"
            }
            return false
        })
        this.submitTarget.disabled = !allInsured
    }

    update() {
        this.checkFields()
    }
}