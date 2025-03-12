import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["source", "container"]

    connect() {

    }

    duplicateFields() {
        var orig = this.sourceTarget;
        var clone = orig.cloneNode(true);
        clone.id = '';

        var count = this.visibleCount() + 1;

        clone.querySelectorAll('label').forEach(function (element) {
            element.htmlFor = element.htmlFor.replace(0, count);
        });
        clone.querySelectorAll('input, select').forEach(function (element) {
            element.id = element.id.replace(0, count);
            element.name = element.name.replace(0, count);
            element.required = false;
        });

        clone.querySelector('.duplicate-number').innerHTML = count;

        if (count > 1) {
            clone.querySelector('.duplicate-remove').classList.remove('hidden');
        } else {
            clone.querySelector('.duplicate-remove').classList.add('hidden');
        }

        clone.querySelectorAll('input:not([type=checkbox])').forEach(function (element) {
            element.value = '';
        });
        clone.querySelectorAll('input[type=checkbox]').forEach(function (element) {
            element.checked = false;
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

    remove(event) {
        event.preventDefault();
        let duplicateField = event.target.closest('.duplicate-field')
        duplicateField.classList.add("hidden");
        duplicateField.querySelectorAll("input:not([type=hidden])").forEach((input) => {
            input.value = ''
        });
        duplicateField.querySelector("input[type=hidden].duplicate-fields-destroy").value = true;

        var count = this.visibleCount();
        let removeButtons = this.containerTarget.querySelectorAll('.duplicate-remove');
        if (count > 1) {
            removeButtons.forEach((button) => {
                button.classList.remove('hidden');
            });
        } else {
            removeButtons.forEach((button) => {
                button.classList.add('hidden');
            });
        }

    }

    visibleCount() {
        return this.containerTarget.querySelectorAll('.duplicate-field:not(.hidden)').length;
    }
}