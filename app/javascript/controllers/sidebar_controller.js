import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['buttonIcon', 'drawer', 'appName', 'actionButton']

    toggle() {
        this.drawerTarget.classList.toggle('drawer');
        if(this.buttonIconTarget.innerText === 'arrow_back') {
            this.buttonIconTarget.innerText = 'arrow_forward';
            this.actionButtonTarget.classList.add('center');
            this.appNameTarget.style.display = 'none';
        } else {
            this.buttonIconTarget.innerText = 'arrow_back'
            this.actionButtonTarget.classList.remove('center');
            this.appNameTarget.style.display = 'flex';
        }
    }
}
