import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.inputs = this.element.querySelectorAll('input, textarea');

        const addClassToLabel = function (input) {
            if(input instanceof Event) { input = input.target }
            const label = input.parentElement.querySelector('label');
            if(!label) { return }
            if(input.value && input.value.length > 0) {
                label.classList.add('active');
                input.classList.add('active');
            } else {
                label.classList.remove('active');
                input.classList.remove('active');
            }
        }

        this.addClassToLabel = addClassToLabel;

        const errorCleaner = function (input) {
            if(input instanceof Event) { input = input.target }
            const error = input.parentElement.parentElement.querySelector('.error-text');
            if(error) { error.innerText = '' }
            input.parentElement.classList.remove('invalid');
        }

        this.errorCleaner = errorCleaner;

        this.inputs.forEach((input) => {
            if(input.type === 'file') { return }
            addClassToLabel(input);
            input.addEventListener('input', addClassToLabel);
            input.addEventListener('input', errorCleaner);
        });
    }

    disconnect() {
        this.inputs.forEach((input) => {
            input.removeEventListener('input', this.addClassToLabel);
            input.removeEventListener('input', this.errorCleaner);
        })
    }
}
