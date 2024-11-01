import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        let element = this.element;
        setTimeout(function() {
            element.classList.remove('active');
        }, 3000)
    }

    disconnect() {
        this.element.classList.remove('active');
    }
}
