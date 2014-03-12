=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end
Pbs::Application.routes.draw do
  
  get "invitations/new"
  get "invitations/create"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  resources :users, only: [:show, :edit, :update] do
    member do
      get 'home'
    end
  end
  
  resources :completed_routines, except: [:show, :destroy]
  resources :awards, only: [:new, :create]
  resources :routines
  resources :people do
    member do
      get 'reports'
    end
    resources :goals, shallow: true
  end
  resources :links, only: [:destroy]
  resources :messages, only: [:update, :new, :create]
  resources :invitations, only: [:new, :create] do
    member do
      get 'respond' # TODO UGH This should be put or post, but I can't test it.
    end
  end

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  
  # From: http://railscasts.com/episodes/241-simple-omniauth-revised
  # Except I had to change "match" to "get", as suggested here: https://github.com/RailsApps/rails-composer/issues/111
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  
  # LCR
  get "sessions/create"
  get "sessions/destroy"
  get "welcome/index"
  get "welcome/index", as: "signin"
  get "welcome/privacy"
  get "welcome/terms"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
