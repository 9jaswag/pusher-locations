Rails.application.routes.draw do
  get 'trips/index'

  get 'trips/new'

  get 'trips/create'

  get 'trips/show'

  get 'trips/update'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
