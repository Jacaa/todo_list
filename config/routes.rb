Rails.application.routes.draw do
  
  root 'static_pages#index'
  get  'users/new'
  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users
end
