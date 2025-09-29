Rails.application.routes.draw do
  if defined?(Rswag::Ui::Engine)
    mount Rswag::Ui::Engine => "/api-docs"
  end
  if defined?(Rswag::Api::Engine)
    mount Rswag::Api::Engine => "/api-docs"
  end
  devise_for :users
  resources :posts do
    resources :comments, only: [ :create, :destroy, :edit, :update ]
  end

  resources :users

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "posts#index"

  # Defines API namespace
  namespace :api do
    namespace :v1 do
      post "login", to: "auth#login"
      resources :posts, only: [ :index, :show, :create, :update, :destroy ] do
        resources :comments, only: [ :index, :show, :create, :update, :destroy ]
      end
    end
  end
end
