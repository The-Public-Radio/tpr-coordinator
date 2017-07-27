Rails.application.routes.draw do
  resources :orders
  resources :users
  resources :shipments

  # resources :shipments do
  #   resources :radios
  # end
  resources :radios

  put '/shipments', to: 'shipments#update'
  patch '/shipments', to: 'shipments#update'
  get '/health', to: 'monitoring#health'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
