import { Controller } from "stimulus"
import debounce from "lodash/debounce"

//  This controller expects a "form" target in the DOM and uses a submit method
//  that calls requestSubmit to submit the form after a 200ms debounce.
//  We will use this to submit filter criteria without having to have a "Filter" button.
export default class extends Controller {
  static targets = [ "form" ]

  connect() {
    this.submit = debounce(this.submit.bind(this), 200)
  }

  submit() {
    this.formTarget.requestSubmit()
  }
}
