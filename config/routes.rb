Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'home#index'

  devise_for :users
  get 'home/index'

  resources :pets do
    get 'routes'
    get 'new_route'
    get 'show_route'
  end
  resources :walks, :tracks, :locations
  
  resources :users do
  	get 'walker', :on => :collection
  	post 'hire_walker', :on => :collection
  end
end
