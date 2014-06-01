NinetyNineCats::Application.routes.draw do

  root to: "cats#index"

  resources :cats, except: [:destroy]
  resources :cat_rental_requests, only: [:create, :new] do
    member do
      patch 'approve'
      patch 'deny'
    end
  end

  resources :users, only: [:new, :create]

  resource :session, only: [:create, :destroy, :new]

end
