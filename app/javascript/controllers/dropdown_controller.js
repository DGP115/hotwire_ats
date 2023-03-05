import { Controller } from "stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["content"]  //This 'content' target is in /nav/notifications.html.erb

  connect() {
    this.open = false
  }

  toggle() {
    if (this.open) {
      this._hide()
    } else {
      this.show()
    }
  }

  show(){
    this.open = true
    this.contentTarget.classList.add("open")
    this.element.setAttribute("aria-expanded", "true")
  }

  _hide(){
    this.open = false
    this.contentTarget.classList.remove("open")
    this.element.setAttribute("aria-expanded", "false")
  }

  //  We do not want the dropdown menu to stay open permanently — any click outside of the menu’s
  //  content should close the menu. To accomplish this, in the notifications partial we added a
  //  data-action to listen to click events on the window, calling dropdown#hide on each click.

  // 'hide' checks if the click event occurred within the dropdown menu (this.element ) and if the
  // dropdown menu is open. If the click was outside of the dropdown menu and the menu is open,
  // _hide runs and the dropdown is closed.
  hide(){
    if (this.element.contains(event.target) === false && this.open) {
      this._hide()
    }
  }
}

