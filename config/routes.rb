Rails.application.routes.draw do
  root to: 'tasks#index'

  resources :tasks
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resource :session, only: [:new, :create, :destroy]

  namespace :admin do
    resources :users
  end
end
