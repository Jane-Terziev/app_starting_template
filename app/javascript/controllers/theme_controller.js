import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.body = document.querySelector('body');
        if(sessionStorage.getItem('theme')) {
            this.body.classList.add(sessionStorage.getItem('theme'));
        } else {
            this.body.classList.add('light');
        }
    }

    toggle() {
        if(this.body.classList.contains('dark')) {
            this.body.classList.remove('dark');
            this.body.classList.add('light');
            sessionStorage.setItem('theme', 'light');
        } else {
            this.body.classList.remove('light');
            this.body.classList.add('dark');
            sessionStorage.setItem('theme', 'dark');
        }
    }
}
