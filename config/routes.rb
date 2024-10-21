Rails.application.routes.draw do
  resources :tasks
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :labels, only: [:index, :new, :create, :edit, :update, :destroy]

  namespace :admin do
    resources :users
    resources :tasks
  end
end
