Rails.application.routes.draw do
  resources :orders
  resources :users

  resources :shipments do
    resources :radios
  end

  put '/shipments', to: 'shipments#update'
  patch '/shipments', to: 'shipments#update'
  get '/health', to: 'monitoring#health'
  get '/', to: 'monitoring#health'
  post '/radios', to: 'radios#create'
  put '/radios', to: 'radios#update'
  get '/radios', to: 'radios#index'
  get '/radios/:id', to: 'radios#show'


  get '/shipments/:id/next_radio', to: 'shipments#next_unboxed_radio'
  put '/shipments/:id/radios', to: 'radios#update_radio_to_boxed'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
