Rails.application.routes.draw do
  root 'home#index'

  resources :events
  resources :event_details, path: '/event-details'
  get 'about', to: 'home#about'

  resources :users
  resources :participants

  get 'verify-email', to: 'users#verify'
  get 'resend-verification', to: 'users#resend_verification'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'create-account', to: 'users#new'
  get 'welcome', to: 'users#welcome'
  get 'reset-password', to: 'users#reset_load'
  post 'reset-password', to: 'users#reset_confirm'
  post 'reset-password-save', to: 'users#reset_save'
  get 'logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
