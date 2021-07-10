# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[sessions passwords registrations]

  resources :homes

  post '/log_in', to: 'session#log_in'
  post '/log_out', to: 'session#log_out'
  get '/user', to: 'users#show'
  post '/sign_up', to: 'users#sign_up'
end
