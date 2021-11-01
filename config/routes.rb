# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      post 'auth', to: 'auth#verify'
      get 'me', to: 'auth#me'

      post 'facebook/data_deletion', to: 'facebook#data_deletion'

      resources :images, only: %i[create]
      resources :potential_matches, only: %i[index]
    end
  end

  get 'facebook/data_deletion', to: 'api/v1/facebook#deletion_status'
end
