Rails.application.routes.draw do

  # farmer
  devise_for :farmers, controllers: {
    sessions:      'farmers/sessions',
    passwords:     'farmers/passwords',
    registrations: 'farmers/registrations'
  }

  namespace :farmers do
    resources :recipes, only: [:new, :create, :edit, :update, :destroy]
      get 'recipes/confirm'
    resources :events, only: [:new, :create, :edit, :update, :destroy]
      get 'events/confirm'
    resources :news, only: [:create, :destroy]
  end

  scope module: :farmers do
    resources :farmers, only: [:show, :edit, :update]
    get 'farmers/:id/unsubscribe' => 'farmers#unsubscribe', as: 'farmers_unsubscribe'
    patch 'farmers/:id/withdraw'  => 'farmers#withdraw',    as: 'farmers_withdraw'
  end

  # customer
  devise_for :customers, controllers: {
    sessions:      'customers/sessions',
    passwords:     'customers/passwords',
    registrations: 'customers/registrations'
  }

  scope module: :customers do
    root 'homes#top'
    get 'about' => 'homes#about'

    resources :recipes, only: [:index, :show] do
      resource :favorite_recipes, only: [:create, :destroy]
    end
    resources :events, only: [:index, :show] do
      resource :favorite_events, only: [:create, :destroy]
    end

    resources :farmers, only: [:index, :show]
    resources :follows, only: [:index, :create, :destroy]
    resources :reservations, only: [:new, :index, :show, :create, :destroy]
      post 'reservations/confirm'
      get 'reservations/thanx'
    resource :profiles, only: [:show, :edit, :update]
      get 'customer/favorites' => 'profiles#favorite'
      get 'customer/unsubscribe' => 'profiles#unsubscribe'
      patch 'customer/withdraw'  => 'profiles#withdraw'
  end

  # farmer-customer
  resources :chat, only: [:create, :destroy]

  # admin
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }

  namespace :admins do
    root 'farmers#index'
    resources :customers, only: [:index]
  end

end
