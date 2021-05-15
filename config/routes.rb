Rails.application.routes.draw do

  # farmer
  devise_for :farmers, controllers: {
    sessions:      'farmers/sessions',
    passwords:     'farmers/passwords',
    registrations: 'farmers/registrations'
  }

  namespace :farmers do
    resources :recipes, except: [:index, :show]
      get '/:id/recipes' => 'recipes#recipe_index', as: 'recipe_index'
    resources :events, except: [:index] do
      resources :schedules, only: [:edit, :update, :destroy]
      patch 'schedules/:id/withdraw' => 'schedules#withdraw', as: 'schedule_withdraw'
    end
      get '/:id/events'           => 'events#event_index', as: 'event_index'
    resources :news, only: [:create, :destroy]
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

    resources :farmers, only: [:index, :show] do
      resources :follows, only: [:index, :create, :destroy]
    end
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
