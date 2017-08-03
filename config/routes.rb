Rails.application.routes.draw do

  root 'static_pages#index'

  # Login 
  get     '/login',  to: 'sessions#new'
  post    '/login',  to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'
  
    # Signup
  get     '/signup', to: 'users#new'
  post    '/signup', to: 'users#create'
  
  resources :users
end
