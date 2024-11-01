import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        if(sessionStorage.getItem('theme')) {
            this.element.classList.add(sessionStorage.getItem('theme'));
        } else {
            this.element.classList.add('light');
        }
    }

    toggle() {
        if(this.element.classList.contains('dark')) {
            this.element.classList.remove('dark');
            this.element.classList.add('light');
            sessionStorage.setItem('theme', 'light');
        } else {
            this.element.classList.remove('light');
            this.element.classList.add('dark');
            sessionStorage.setItem('theme', 'dark');
        }
    }
}
