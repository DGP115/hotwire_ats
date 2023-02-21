# frozen_string_literal: true

#  The server side of the Stimulus-Reflex based drag and drop
class DraggableReflex < ApplicationReflex
  # Called by draggable_controller.js -> end
  def update_record(resource, field, value)
    # element is provided by the stimulus stimulate method we invoked in draggable_controller.js.
    # It amounts to the "card" div of the applicant in question.
    # In the card partial, we id each card with the applicant's id.  So we can retrieve it below
    id = element.dataset.id

    #  Now this is cool.
    #   - "resource", as passed to this method, is the string "Applicant" [as set by us in
    #     index.html.erb].
    #   - The constantize function of Rails tells it to see if it has a declaration that translates
    #     to "Applicant".  So, we effectively are telling Rails that "Applicant" is a class and it
    #     should treat it as a class name, which means it has a .find method, which means
    #     "resource" here actually "becomes" an Applicant object with id of id - AMAZING
    resource = resource.constantize.find(id)

    #   This line simply calls the update method of the applicant object passing "status" as the
    #   field to update to value "value"
    resource.update("#{field}": value)

    morph :nothing
  end
end
