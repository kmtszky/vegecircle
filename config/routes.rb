Rails.application.routes.draw do

  namespace :customers do
    get 'reservations/index'
    get 'reservations/new'
    get 'reservations/confirm'
    get 'reservations/thanx'
    get 'reservations/show'
  end
  namespace :customers do
    get 'follows/index'
  end
  namespace :customers do
    get 'favorite_events/index'
  end
  namespace :customers do
    get 'favorite_recipes/index'
  end
  namespace :customers do
    get 'profiles/show'
    get 'profiles/edit'
    get 'profiles/unsubscribe'
  end
  namespace :customers do
    get 'events/index'
    get 'events/show'
  end
  namespace :customers do
    get 'recipes/index'
    get 'recipes/show'
  end
  namespace :customers do
    get 'farmers/index'
    get 'farmers/show'
  end
  namespace :customers do
    get 'homes/top'
    get 'homes/about'
  end
  namespace :farmers do
    get 'events/new'
    get 'events/confirm'
    get 'events/edit'
  end
  namespace :farmers do
    get 'recipes/new'
    get 'recipes/confirm'
    get 'recipes/edit'
  end
  namespace :admins do
    get 'customers/index'
  end
  namespace :admins do
    get 'farmers/index'
  end
  namespace :farmers do
    get 'farmers/show'
    get 'farmers/edit'
    get 'farmers/unsubscribe'
  end
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }

  # farmer
  devise_for :farmers, controllers: {
    sessions:      'farmers/sessions',
    passwords:     'farmers/passwords',
    registrations: 'farmers/registrations'
  }

  # customer
  devise_for :customers, controllers: {
    sessions:      'customers/sessions',
    passwords:     'customers/passwords',
    registrations: 'customers/registrations'
  }
end
