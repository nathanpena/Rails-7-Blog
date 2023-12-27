Rails.application.routes.draw do
  root "posts#index"
  resources :logins, only: %i[new create]
  resources :registrations, only: %i[new create]
  resources :posts
end
