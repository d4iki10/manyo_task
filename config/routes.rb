Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    resources :users
  end

  get '/sessions', to: redirect('/sessions/new')
  get '/users', to: redirect('/users/new')
end
