# frozen_string_literal: true

# App user model taken from devise
class User < ApplicationRecord
  include ActionText::Attachable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :account
  accepts_nested_attributes_for :account

  belongs_to :invited_by, required: false, class_name: 'User'
  has_many :invited_users, class_name: 'User', foreign_key: 'invited_by_id',
                           dependent: :nullify, inverse_of: :invited_by

  has_many :emails, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :comments, dependent: :destroy

  after_create_commit :generate_email_alias

  def generate_email_alias
    email_alias = "#{email.split('@')[0]}-#{id[0...4]}"
    update_column(:email_alias, email_alias)
  end

  def name
    [first_name, last_name].join(' ').presence || '(Not set)'
  end

  def reset_invite!(inviting_user)
    update(invited_at: Time.current, invited_by: inviting_user)
    update_users_invitation_display
  end

  def update_users_invitation_display
    broadcast_update_later_to(
      self,
      target: "user_#{id}",
      partial: 'users/user'
    )
  end

  def to_attachable_partial_path
    'users/mention_attachment'
  end
end
