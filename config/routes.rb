NinetyNineCats::Application.routes.draw do

  root to: "sessions#new"

  resources :cats
  resources :cat_rental_requests, only: [:create, :delete, :new] do
    member do
      patch 'approve'
      patch 'deny'
    end
  end

  resources :users, :only => [:new, :create]

  resource :session

end
