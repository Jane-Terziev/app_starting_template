import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    toggle(event) {
        this.element.classList.toggle('drawer');
        const icon = event.target.querySelector('i');
        if(icon.innerText === 'arrow_back') {
            icon.innerText = 'arrow_forward';
            event.target.classList.add('center');
            this.element.querySelector('h6').style.display = 'none';
        } else {
            icon.innerText = 'arrow_back'
            event.target.classList.remove('center');
            this.element.querySelector('h6').style.display = 'flex';
        }
    }
}
