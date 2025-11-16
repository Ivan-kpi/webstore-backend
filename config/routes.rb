Rails.application.routes.draw do
  #
  # === CORS FIX: allow OPTIONS preflight for ALL endpoints ===
  #
  match "*path", to: "application#cors_preflight", via: [:options]

  #
  # === DEVlSE (JSON + JWT, old URL format) ===
  #
  devise_for :users,
    defaults: { format: :json },
    skip: :all,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  devise_scope :user do
    post   "users/sign_in",  to: "users/sessions#create"
    delete "users/sign_out", to: "users/sessions#destroy"

    post   "users",          to: "users/registrations#create"
  end

  #
  # === API NAMESPACE ===
  #
  
  get "/me", to: "me#show"

  resources :items
  resources :orders, only: [:index, :show, :create]
  resources :users

end


