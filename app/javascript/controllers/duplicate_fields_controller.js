import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["source", "container"]

    connect() {
    }

    duplicateFields() {
        var orig = this.sourceTarget;
        var clone = orig.cloneNode(true);
        clone.id = '';
        var count = document.querySelectorAll("#boat-fields .boat > *").length + 1;

        clone.querySelectorAll('label').forEach(function (element) {
            element.htmlFor = element.htmlFor.replace(0, count);
        });
        clone.querySelectorAll('input, select').forEach(function (element) {
            element.id = element.id.replace(0, count);
            element.name = element.name.replace(0, count);
            element.required = false;
        });
        clone.querySelector('.boat-number').innerHTML = count;

        clone.querySelectorAll('input').forEach(function (element) {
            element.value = '';
        });
        clone.querySelectorAll('select').forEach(function (element) {
            element.value = 'request';
        });

        this.containerTarget.append(clone);
        // Make clone node visible with a smooth scroll taking 500ms
        clone.scrollIntoView({
            behavior: 'smooth',
            block: 'start',
            inline: 'nearest'
        });

    }
}