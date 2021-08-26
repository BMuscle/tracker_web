# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users, skip: %i[sessions passwords registrations confirmations]
  devise_scope :user do
    get 'users/confirmation/new', to: 'users/confirmations#new', as: :new_user_confirmation
    post 'users/confirmation', to: 'users/confirmations#create', as: :user_confirmation
    post 'users/confirmation/authenticate', to: 'users/confirmations#authenticate'
  end

  resources :homes, only: :index
  resources :teams, only: %i[index show create] do
    collection do
      post 'invites/confirm', to: 'team_invites#confirm', as: :invite_confirm
      put 'invites/:id', to: 'team_invites#update', as: :invite
    end

    resources :rooms, only: %i[index show create]
    resources :user_in_rooms, only: %i[create]
  end

  post '/log_in', to: 'session#log_in'
  post '/log_out', to: 'session#log_out'
  get '/user', to: 'users#show'
  post '/sign_up', to: 'users#sign_up'

  namespace :agent_api do
    resources :locations, only: %i[create]
    post '/log_in', to: 'users#log_in'
    resources :teams, only: %i[index show]
    resources :rooms, only: %i[index show]
  end
end
