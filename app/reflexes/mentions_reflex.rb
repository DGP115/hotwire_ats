# frozen_string_literal: true

#  Reflex [server-side] portion of Tributejs 'mentions'.
#   This reflex queries the database for mentionable users and then builds an array of hashes with
#   name and sgid keys.
#
#   Then we use the set_dataset_property CableReady operation to update the userList value.
#   When this operation runs,
#       - the value of userList changes,
#       - Stimulus fires the userListValueChanged callback, and
#       - Tribute gets an updated list of mentionable users.
class MentionsReflex < ApplicationReflex
  def user_list
    users = current_user
            .account
            .users
            .where.not(id: current_user.id)
            .map { |user| { sgid: user.attachable_sgid, name: user.name } }
            .to_json

    cable_ready.set_dataset_property(
      name: 'mentionsUserListValue',
      selector: '#comment_comment',  # I think this is the 'id="comment"' in partial comment
      value: users
    )
    morph :nothing
  end
end
