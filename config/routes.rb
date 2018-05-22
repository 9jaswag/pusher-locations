Rails.application.routes.draw do
  resources :trips do
    resources :checkins, only: :create
  end
  root 'trips#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
