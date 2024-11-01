import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['drawer']

    toggle() {
        if(this.drawerTarget.open) {
            this.drawerTarget.close();
        } else {
            this.drawerTarget.show();
        }
    }
}
