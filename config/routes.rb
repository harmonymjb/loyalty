Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'users/registrations' }

  resources :stores do
    resources :points_transactions
  end

  resources :users do
    resources :stores
    resources :accounts do
      resources :points_transactions
    end
  end

  root to: "users#index"
end
