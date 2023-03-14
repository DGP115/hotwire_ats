import ApplicationController from './application_controller'
import Tribute from 'tributejs'
import Trix from 'trix'

export default class extends ApplicationController {
  static values = {
    userList: Array
  }

  /*
    1.  Setup the controller,
    2.  Initialize a new Tribute instance and
    3.  Call reflex (server-side) with this.stimulate:
  */
  connect() {
    super.connect()
    this.editor = this.element.editor
    this.initializeTribute()
    this.stimulate("Mentions#user_list")
  }

  /*
    Initialize a new Tribute instance and attach that instance to the controller’s DOM element.
    The most important option passed in to Tribute is the empty 'values' array. We populate that array with this.stimulate("Mentions#user_list") in the connect lifecycle method and with userListValueChanged.  That data comes from the Reflex
  */
  initializeTribute() {
    this.tribute = new Tribute({
      allowSpaces: true,
      lookup: 'name',     // The column to search against in the object
      values: [],         // The array that is searched [contains hashes {sgif, user.name}]
      noMatchTemplate: function () { return 'No matches!'; },
    })
    this.tribute.attach(this.element)
    this.element.addEventListener('tribute-replaced', this.replaced.bind(this))
    this.tribute.range.pasteHtml = this._pasteHtml.bind(this)
    this.userListValueChanged.bind(this)
  }

  disconnect() {
    this.tribute.detach(this.element)
  }

  /*
    userListValueChanged takes advantage of built-in Stimulus value change callbacks.
    Recall:  At the top of the controller, we defined a userList value, which expects to be an
             array.
             When the userList value changes (which the server-side Mentions#user_list reflex will handle), Stimulus runs the userListValueChanged callback which calls Tribute.append to populate the list users that can be mentioned in a comment.
  */
  userListValueChanged() {
    if (this.userListValue.length > 0 && this.tribute !== undefined) {
      this.tribute.append(0, this.userListValue)
    }
  }

  /*
    'replaced' and '_pasteHtml' handle inserting mentioned users into the Trix editor cleanly, creating a Trix attachment and embedded that attachment inline with the rest of the text in the comment.
  */
  replaced(e) {
    let mention = e.detail.item.original
    let attachment = new Trix.Attachment({
      content: this.mentionContent(mention.name),
      sgid: mention.sgid,
    })
    this.editor.insertAttachment(attachment)
    this.editor.insertString(" ")
  }

  mentionContent(name) {
    return "<span class=\"text-blue-500\">@" + name + "</span>"
  }

  _pasteHtml(html, startPos, endPos) {
    let range = this.editor.getSelectedRange()
    let position = range[0]
    let length = endPos - startPos

    this.editor.setSelectedRange([position - length, position])
    this.editor.deleteInDirection("backward")
  }
}
