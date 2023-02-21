import ApplicationController from './application_controller'

import Sortable from 'sortablejs'

/* This is the custom StimulusReflex controller for the Draggable Reflex.
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

  static targets = [ 'list' ]
  static values = {
    attribute: String,
    resource: String
  }

  connect () {
    super.connect()
    // add your code here, if applicable
    this.listTargets.forEach(this.initializeSortable.bind(this))
  }

  // Make the target element a Sortable list.
  //   The group option is how we enable dragging between lists on a page [like between applicant statuses].  The group value is whatever we want
  initializeSortable(target) {
    new Sortable(target, {
      group: 'shared',
      animation: 100,
      sort: false,
      onEnd: this.end.bind(this)
    })
  }

  // The call to this.stimulate triggers a reflex action on the server.
  // In the stimulate call, we pass in data from the DOM event and values from the
  // Stimulus controller.
  // These arguments are used by the server-side reflex action to find and update the
  // correct applicant in the database.
  // So, we are telling stimulate - which is provided by Stimulus-Reflex to:
  // 1.  Call DraggableReflex#update_record method
  // 2   We pass to it event.item which is the "thing" the stimulus controller is attached to in
  //     the DOM, so it is the content of the "card", which is tagged with the applicant's id
  // 3.  It passes in this.resourceValue, which we gave it (in index.html.erb) as "Applicant".
  // 4.  It passes in this.attributeValue, which we gave it (in index.html.erb) as "stage".
  // 5.  It passes in value, which was set (in index.html.erb) as data-new-value="<%= key.to_s",
  //     which maps to the applicant stage the user dropped the applicant in.
  end(event) {
    const value = event.to.dataset.newValue
    this.stimulate(
      "Draggable#update_record",
      event.item,
      this.resourceValue,
      this.attributeValue,
      value
    )
  }

  /* Reflex specific lifecycle methods.
   *
   * For every method defined in your Reflex class, a matching set of lifecycle methods become available
   * in this javascript controller. These are optional, so feel free to delete these stubs if you don't
   * need them.
   *
   * Important:
   * Make sure to add data-controller="draggable" to your markup alongside
   * data-reflex="Draggable#dance" for the lifecycle methods to fire properly.
   *
   * Example:
   *
   *   <a href="#" data-reflex="click->Draggable#dance" data-controller="draggable">Dance!</a>
   *
   * Arguments:
   *
   *   element - the element that triggered the reflex
   *             may be different than the Stimulus controller's this.element
   *
   *   reflex - the name of the reflex e.g. "Draggable#dance"
   *
   *   error/noop - the error message (for reflexError), otherwise null
   *
   *   reflexId - a UUID4 or developer-provided unique identifier for each Reflex
   */

  // Assuming you create a "Draggable#dance" action in your Reflex class
  // you'll be able to use the following lifecycle methods:

  // beforeDance(element, reflex, noop, reflexId) {
  //  element.innerText = 'Putting dance shoes on...'
  // }

  // danceSuccess(element, reflex, noop, reflexId) {
  //   element.innerText = '\nDanced like no one was watching! Was someone watching?'
  // }

  // danceError(element, reflex, error, reflexId) {
  //   console.error('danceError', error);
  //   element.innerText = "\nCouldn\'t dance!"
  // }

  // afterDance(element, reflex, noop, reflexId) {
  //   element.innerText = '\nWhatever that was, it\'s over now.'
  // }

  // finalizeDance(element, reflex, noop, reflexId) {
  //   element.innerText = '\nNow, the cleanup can begin!'
  // }
}
