# frozen_string_literal: true

Rails.application.routes.draw do
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
      # match 'invites/:id', to: 'team_invites#update', via: [:put, :patch], as: :invite
      put 'invites/:id', to: 'team_invites#update', as: :invite
    end
  end

  post '/log_in', to: 'session#log_in'
  post '/log_out', to: 'session#log_out'
  get '/user', to: 'users#show'
  post '/sign_up', to: 'users#sign_up'
end
