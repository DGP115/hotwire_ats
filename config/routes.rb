# frozen_string_literal: true

Rails.application.routes.draw do
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

  # pages
  get 'dashboard/show'

  # Jobs
  resources :jobs
end
