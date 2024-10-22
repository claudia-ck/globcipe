Rails.application.routes.draw do
  devise_for :users, controllers: { registraions: 'users/registrations' }
  root to: "recipes#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  get "favourites", to: "pages#favourites"

  resources :recipes, only: [:index, :show] do
    resources :favourites, only: [:create, :edit, :update]
  end
  resources :ingredients, only: [:show] do
    resources :ingredient_reviews, only: [:create, :update, :edit, :destroy, :index]
    resources :shops, only: [:new, :create]
    resources :ingredient_shops, only: [:create]

  end

  get "aboutglobcipe", to: "pages#aboutglobcipe"
  get "meetteam", to: "pages#meetteam"

  resources :favourites, only: [:destroy]


end
