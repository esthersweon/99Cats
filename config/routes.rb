NinetyNineCats::Application.routes.draw do

  root to: "cats#index"
  resources :cats
  resources :cat_rental_requests, :only => [:create, :delete, :new] do
    member do
      patch 'approve'
      patch 'deny'
    end
  end
  resources :users, :only => [:new, :create]

  resource :session

end
