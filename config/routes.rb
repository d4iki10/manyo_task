Rails.application.routes.draw do
  resources :tasks
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resource :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    resources :users
  end

  root to: 'sessions#new'
end
