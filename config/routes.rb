Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'home#index'

  devise_for :users
  get 'home/index'

  resources :users, :pets

end
