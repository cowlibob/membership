import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["membershipSelect", "pricingTable", "renewalMembershipClass", "familySection", "nextButton"];

  connect() {
    console.log("Membership controller connected");

    this.updateNextButtonState();
  }

  selectMembership(event) {
    event.preventDefault();
    const table = event.currentTarget.closest(".pricing-table");

    this.pricingTableTargets.forEach((table) => {
      table.classList.remove("selected", "bg-green-900");
    });

    table.classList.add("selected", "bg-green-900");

    if (table.classList.contains("family")) {
      this.familySectionTargets.forEach((section) => {
        section.classList.remove("disabled");
        section.querySelectorAll("input").forEach((input) => {
          input.disabled = false;
        });
      });
    } else {
      this.familySectionTargets.forEach((section) => {
        section.classList.add("disabled");
        section.querySelectorAll("input").forEach((input) => {
          input.disabled = true;
        });
      });
    }

    this.renewalMembershipClassTarget.value = event.currentTarget.dataset.value;
  }

  updateNextButtonState() {
    const nextButton = this.nextButtonTarget;
    const currentTab = document.querySelector("#tabs .active");
    const nextTab = currentTab.nextElementSibling;

    if (nextTab && !nextTab.classList.contains("disabled")) {
      nextButton.classList.remove("disabled");
    } else {
      nextButton.classList.add("disabled");
    }
  }
}