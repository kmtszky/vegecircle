Rails.application.routes.draw do

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
