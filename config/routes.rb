Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :orders, only: :index
      resources :products
      resources :tokens, only: :create
      resources :users
    end
  end
end
