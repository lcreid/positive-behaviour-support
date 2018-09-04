# frozen_string_literal: true

Pbs::Application.routes.draw do
  get "invitations/new"
  get "invitations/create"

  # A user should go straight to their list of subjects (people).
  # In the future that could be further optimized (maybe) to go to the subject,
  # if the user has only one subject.
  resources :users, only: %i[show edit update] do
    member do
      get "home"
    end
  end

  # TODO: completed_routines could be shallowly nested under routines.
  resources :completed_routines, except: %i[show destroy]
  resources :awards, only: %i[new create]
  resources :people do
    member do
      get "reports"
    end
    resources :goals, shallow: true, except: %i[show]
    resources :routines, shallow: true do
      member do
        get "reports"
      end
    end
  end
  resources :links, only: [:destroy]
  resources :messages, only: %i[index create new update]
  resources :invitations, only: %i[create new] do
    member do
      get "respond" # TODO: This should be put or post, but I can't test it.
    end
  end

  # You can have the root of your site routed with "root"
  root "welcome#index"

  # From: http://railscasts.com/episodes/241-simple-omniauth-revised
  # Except I had to change "match" to "get", as suggested here: https://github.com/RailsApps/rails-composer/issues/111
  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/")
  get "signout", to: "sessions#destroy", as: "signout"

  # LCR
  get "sessions/create"
  get "sessions/destroy"
  get "welcome/index"
  get "welcome/index", as: "signin"
  get "welcome/privacy"
  get "welcome/terms"
end
