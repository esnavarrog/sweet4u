Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"
  resources :profiles, path: 'perfiles', only: [:index, :show, :edit, :update]

  get 'delete_image_profile/:image_number', to: 'profiles#delete_image_profile', as: 'delete_image_profile'

  # Modelos para mensajería
  mount ActionCable.server => '/cable'
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
end
