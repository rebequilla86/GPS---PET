Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'home#index'

  devise_for :users
  get 'home/index'

  resources :pets
  resources :routes
  
  resources :users do
  	get 'walker', :on => :collection
  end
end
