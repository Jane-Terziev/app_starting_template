import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        elementId: String
    }

    connect() {
        this.drawer = document.getElementById(this.elementIdValue);
    }

    toggle() {
        console.log(this.drawer);
        if(this.drawer.open) {
            this.drawer.close();
        } else {
            this.drawer.show();
        }
    }
}
