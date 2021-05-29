Rails.application.routes.draw do

  # farmer
  devise_for :farmers, controllers: {
    sessions:      'farmers/sessions',
    registrations: 'farmers/registrations'
  }

  namespace :farmers do
    resources :farmers, only: [:index, :show, :edit, :update]
      get 'farmers/:id/unsubscribe' => 'farmers#unsubscribe',  as: 'farmers_unsubscribe'
      patch 'farmers/:id/withdraw'  => 'farmers#withdraw',     as: 'farmers_withdraw'
      get 'farmers/:id/followers'   => 'farmers#followers',    as: 'farmers_followers'
      get 'farmers/:id/evaluations' => 'farmers#evaluations',  as: 'farmers_evaluations'
      get 'farmers/:id/recipes'     => 'farmers#recipes',      as: 'farmers_recipes'
      get 'farmers/:id/events'      => 'farmers#events',       as: 'farmers_events'
      get 'farmers/:id/calender'    => 'farmers#calender',     as: 'farmers_calender'
    resources :recipes
    resources :events do
      resources :schedules, only: [:show, :edit, :update, :destroy]
      resources :chats, only: [:create]
    end
    resources :news, only: [:create, :destroy]
  end

  # customer
  devise_for :customers, controllers: {
    sessions:      'customers/sessions',
    registrations: 'customers/registrations'
  }

  scope module: :customers do
    root 'homes#top'
    get 'about' => 'homes#about'
    get 'about_for_farmer' => 'homes#about_farmer'
    resource :profiles, only: [:show, :edit, :update]
      get 'customer/followings' => 'profiles#followings', as: 'followings'
      get 'customer/favorites' => 'profiles#favorites', as: 'favorites'
      get 'customer/evaluations' => 'profiles#evaluations', as: 'evaluations'
      get 'customer/unsubscribe' => 'profiles#unsubscribe'
      patch 'customer/withdraw'  => 'profiles#withdraw'
    resources :farmers, only: [:index, :show] do
      resources :follows, only: [:create, :destroy]
      resources :evaluations, only: [:index, :create, :edit, :update, :destroy]
    end
    resources :recipes, only: [:index, :show] do
      resource :favorite_recipes, only: [:create, :destroy]
    end
    resources :events, only: [:index, :show] do
      resource :favorite_events, only: [:create, :destroy]
      resources :chats, only: [:create]
      resources :schedules, only: [:show] do
        get 'reservations/thanx'
        resources :reservations, only: [:new, :show, :create, :destroy]
        post 'reservations/confirm'
        post 'reservations/back'
      end
    end
    resources :reservations, only: [:index]
  end

  get 'search'=> 'searches#search', as: 'search'
  get 'sort'=> 'searches#sort', as: 'sort'


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
