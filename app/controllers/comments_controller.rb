# frozen_string_literal: true

#  Comments Controller
class CommentsController < ApplicationController
  before_action :set_commentable

  def index
    comments = @commentable.comments
                           .includes(:user)
                           .with_rich_text_comment
                           .order(created_at: :desc)
    html = render_to_string(partial: 'comments',
                            locals: { comments: comments, commentable: @commentable })
    render operations: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: "Comments on #{@commentable.name}")
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.commentable = @commentable
    @comment.user_id = current_user.id

    if @comment.save
      html = render_to_string(partial: 'comment', locals: { comment: @comment })
      form_html = render_to_string(partial: 'form',
                                   locals: { comment: Comment.new, commentable: @commentable })
      render operations: cable_car
        .prepend('#comments', html: html)
        .replace('#comment-form', html: form_html)
    else
      html = render_to_string(partial: 'form',
                              locals: { comment: @comment, commentable: @commentable })
      render operations: cable_car
        .inner_html('#comment-form', html: html), status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def set_commentable
    #  Because comments are polymorphic [i.e. can be associated with applicants, jobs, etc.],
    #  we first have to discern what class @commentable should be.
    #  1.  params, for example, will include 'applicant_id' as a key.
    #  2.  The code below converts 'applicant_id' to 'applicant', then constantizes it
    #      to arrive at the class name Applicant.
    #  3.  It then creates/finds @commentable, of class Applicant, with the applicant_id
    #      that was passed in.
    commentable_param = params.keys.detect { |key| key.include?('_id') }
    @commentable = commentable_param.remove('_id')
                                    .classify.constantize.find(params[commentable_param])
  end
end
