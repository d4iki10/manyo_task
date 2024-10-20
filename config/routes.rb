Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    resources :users
    resources :tasks
  end
end
