Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'home#index'

  devise_for :users
  get 'home/index'

  resources :pets do
    get 'routes'
    get 'new_route'
  end
  #resources :walks
  
  resources :users do
  	get 'walker', :on => :collection
  	post 'hire_walker', :on => :collection
  end

  mount DelayedJobWeb => "/delayed_job"
end
