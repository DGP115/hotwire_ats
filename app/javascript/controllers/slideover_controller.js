import { Controller } from "stimulus"

// Connects to data-controller="slideover"
export default class extends Controller {
  // In Stimulus, a target lets you reference important html elements by name.
  //  We reference our targets in stimulus controller methods using 'this.slideoverTarget',
  //  since this is the slideover_controller
  static targets = [ "slideover" ]

  connect() {
    this.backgroundHtml = this.backgroundHTML()
    this.visible = false
  }

  disconnect() {
    if (this.visible) {
      this.close()
    }
  }

  //The event listener that we add when open is called is the other important piece of the
  // SlideoverController. In this event listener, submit:success, is how we close the drawer
  // after a successful form submission.
  open() {
    this.visible = true
    document.body.insertAdjacentHTML('beforeend', this.backgroundHtml)
    this.background = document.querySelector(`#slideover-background`)
    this.toggleSlideover()
    document.addEventListener("submit:success", () => {
      this.close()
    }, { once: true })
  }

  close() {
    this.visible = false
    this.toggleSlideover()
    if (this.background) {
      this.background.classList.remove("opacity-100")
      this.background.classList.add("opacity-0")
      setTimeout(() => {
        this.background.remove()
      }, 500);
    }
  }

  toggleSlideover() {
    this.slideoverTarget.classList.toggle("right-0")
    this.slideoverTarget.classList.toggle("-right-full")
    this.slideoverTarget.classList.toggle("lg:-right-1/3")
  }

  backgroundHTML() {
    return `<div id="slideover-background" class="fixed top-0 left-0 w-full h-full z-20"></div>`;
  }
}
