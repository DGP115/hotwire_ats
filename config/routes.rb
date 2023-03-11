# frozen_string_literal: true

Rails.application.routes.draw do
  # pages
  get 'dashboard/show'
  get 'charts/show', as: 'chart'

  # Comments
  concern :commentable do
    resources :comments, only: %i[index create]
  end

  # Jobs
  resources :jobs

  # Applicants
  #  Include addition of a route and controller action to handle the stage change PATCH request
  #  that occurs when the user drag/drops applicants between hiring stages.
  resources :applicants, concerns: :commentable do
    patch :change_stage, on: :member
    resources :emails, only: %i[index new create show]
    resources :email_replies, only: %i[new]
    get :resume, action: :show, controller: 'resumes'
  end

  #  Notifications
  resources :notifications, only: %i[index]

  # Careers namespace
  namespace :careers do
    resources :accounts, only: %i[show] do
      resources :jobs, only: %i[index show], shallow: true do
        resources :applicants, only: %i[new create]
      end
    end
  end

  # Users [outside of Devise]
  resources :users

  # Invitations for users
  get 'invite', to: 'invites#new', as: 'accept_invite'
  resources :invites, only: %i[create update]

  # Devise routes
  # Defined custom path_names, so urls and url helper methods are a bit easier to read.
  devise_for :users,
             path: '',
             controllers: {
               registrations: 'users/registrations',
               sessions: 'users/sessions'
             },
             path_names: {
               sign_in: 'login',
               password: 'forgot',
               confirmation: 'confirm',
               sign_up: 'sign_up',
               sign_out: 'signout'
             }

  #  authenticated users will have a root route of the dashboard
  authenticated :user do
    root to: 'dashboard#show', as: :user_root
  end
  #  "Just visiting" anonymous users will have a root route of the sessions controller
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
