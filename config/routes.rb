require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'

  namespace :api, defaults: {format: 'json'} do
    resources :products, only: %w(index)
  end
end
