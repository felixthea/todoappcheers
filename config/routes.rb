Todo::Application.routes.draw do
  resources :users do
    get 'completed'
  end
  resource :session
  resources :goals do
    resources :cheers, only: :create
  end
end
