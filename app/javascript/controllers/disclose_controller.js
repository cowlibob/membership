import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["child"];
    toggle(event) {
        const renewalValue = event.target.closest("tr").dataset.renewal;
        event.target.innerText = event.target.innerText === "-" ? "+" : "-";
        this.childTargets.forEach((child) => {
            if (child.dataset.renewal === renewalValue) {
                child.classList.toggle("hidden");
            }
        });
    }
}