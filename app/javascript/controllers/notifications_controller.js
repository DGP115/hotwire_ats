import ApplicationController from './application_controller'

/* This is the custom StimulusReflex controller for the Notifications Reflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  /*
   * Regular Stimulus lifecycle methods
   * Learn more at: https://stimulusjs.org/reference/lifecycle-callbacks
   *
   * If you intend to use this controller as a regular stimulus controller as well,
   * make sure any Stimulus lifecycle methods overridden in ApplicationController call super.
   *
   * Important:
   * By default, StimulusReflex overrides the -connect- method so make sure you
   * call super if you intend to do anything else when this controller connects.
  */

  connect () {
    super.connect()
    // add your code here, if applicable
  }

  /*
    This Stimulus controller’s primary job is to call 'this.stimulate' when the 'read' action is triggered by a user.
      - The 'read' action is defined in views/notifications/notification and assigned there
        to the button we put on each notification.

      - Recall 'stimulate' calls the method we give it - "Notifications#read", in this case.
        That is, the 'read' method in Reflex 'Notifications'.

        In this way, we are making a function call from the client to the server, triggered by the user.
  */
  read() {
    this.stimulate("Notifications#read", this.element)
  }

  /*
    'The beforeRead' function uses the custom lifecycle callbacks that StimulusReflex provides to
     remove the element from the DOM before triggering the reflex. This allows us to optimistically update the DOM to reflect the user’s desired action without waiting on the server to process the change.
  */
  beforeRead(element) {
    element.classList.add("opacity-0")
    setTimeout(() => {
      element.remove()
    }, 150);
  }

}
