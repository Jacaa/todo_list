Rails.application.routes.draw do

  root 'static_pages#index'

  # Login 
  get     '/login',  to: 'sessions#new'
  post    '/login',  to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'
  
  # Signup
  get     '/signup', to: 'users#new'
  post    '/signup', to: 'users#create'
  
  # OmniAuth
  get     '/auth/:provider/callback', to: 'sessions#create_omniauth'
  
  resources :users
  resources :activations,     only: [:new, :create, :edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :tasks,           only: [:create, :destroy, :edit, :update]
  resources :tasks,           only: [:change, :delete_all] do
    member do
      get :change
      delete :delete_all
    end
  end
end
