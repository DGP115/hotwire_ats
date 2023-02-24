import { Controller } from "stimulus"
import Sortable from 'sortablejs'

// Connects to data-controller="drag"
export default class extends Controller {
  static targets = [ 'list' ]
  static values = {
    url: String,
    attribute: String
  }

  // '[name]TargetConnected' is a built-in stimulus callback that runs each time
  //  the target element is added to the DOM
  listTargetConnected() {
    this.listTargets.forEach(this.initializeSortable.bind(this))
  }

  // 'initializeSortable' makes the target element a sortable list.
  //  The 'group' option is how we enable drag and drop between different sortable
  //  lists on the same page.  The group name can be anything we set.
  //  The 'sort: false' option limits the drag and drop to between columns, not within a column

  //  NOTEs:
  //    1.  An instance of a Stimulus controller can have any number elements with the
  //        same target identifier.  In our case we have 4 applicant hiring stages all
  //        within a 'list' target.  But we only have to define this code once and it will
  //        "attached itself" to all of our lists sub-types.

  //    2.  Stimulus callbacks allow us to include code from 3rd-party libraries,
  //        Sortablejs in this case
  initializeSortable(target) {
    new Sortable(target, {
      group: 'shared',
      animation: 100,
      sort: false,
      onEnd: this.end.bind(this)
    })
  }

  //  Send a PATCH request when the user finishes dragging an applicant, hooking into Sortable’s
  //  onEnd option.
  //  'end' grabs the id of the applicant that was moved and combines it with the
  //  url and attribute values to construct a PATCH request to the server.
  end(event) {
    const id = event.item.dataset.id
    const url = this.urlValue.replace(":id", id)
    const formData = new FormData()
    formData.append(this.attributeValue, event.to.dataset.newValue)
    window.mrujs.fetch(url, {
      method: 'PATCH',
      body: formData
    }).then(() => {}).catch((error) => console.error(error))
  }
}
