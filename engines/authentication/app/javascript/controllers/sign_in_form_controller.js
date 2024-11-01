import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['emailInput', 'passwordInput'];

    connect() {
        if(this.emailInputTarget.value.length === 0 || this.passwordInputTarget.value.length === 0) {
            this.emailInputTarget.focus();
            let value = this.emailInputTarget.value;
            this.emailInputTarget.value = '';
            this.emailInputTarget.value = value;
        }

        if(this.passwordInputTarget.value.length > 0) {
            this.passwordInputTarget.focus();
            let value = this.passwordInputTarget.value;
            this.passwordInputTarget.value = '';
            this.passwordInputTarget.value = value;
        }
    }
}
