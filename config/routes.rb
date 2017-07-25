Rails.application.routes.draw do
  resources :orders
  resources :users
  resources :shipments
  resources :radios


  get '/health', to: 'monitoring#health'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
