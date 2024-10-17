Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  root to: 'tasks#index'
  resources :tasks
  resources :users, only: [:new, :create, :show, :edit, :update]
  resource :session, only: [:new, :create, :destroy]
end
