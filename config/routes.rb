# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"

  root 'pages#home'

  get '/privacy_policy', to: 'pages#privacy_policy'
  get '/terms_and_conditions', to: 'pages#terms_and_conditions'

  namespace :api do
    namespace :v1 do
      post 'auth', to: 'auth#verify'
      post 'refresh_token', to: 'auth#refresh'
      post 'logout', to: 'auth#logout'
      get 'me', to: 'auth#me'

      post 'facebook/data_deletion', to: 'facebook#data_deletion'

      resources :images, only: %i[create]
      resources :swipes, only: %i[create]
      resources :potential_matches, only: %i[index]
      resource :location, only: %i[create]
    end
  end

  get 'facebook/data_deletion', to: 'api/v1/facebook#deletion_status'
end
