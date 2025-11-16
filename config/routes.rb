Rails.application.routes.draw do
  #
  # === CORS FIX: allow OPTIONS preflight ===
  #
  match "*path", to: "application#cors_preflight", via: [:options]

  #
  # === API & AUTH ROUTES ===
  #
  namespace :api, defaults: { format: :json } do
    #
    # === Devise (JWT) Routes ===
    #
    devise_for :users,
      skip: :all,
      controllers: {
        sessions: "users/sessions",
        registrations: "users/registrations"
      }

    devise_scope :user do
      post   "login",    to: "users/sessions#create"
      delete "logout",   to: "users/sessions#destroy"

      post   "register", to: "users/registrations#create"
    end

    #
    # === Other API Endpoints ===
    #
    get "/me", to: "me#show"

    resources :items
    resources :orders, only: [:index, :show, :create]
    resources :users
  end
end

