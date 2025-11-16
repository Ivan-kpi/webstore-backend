Rails.application.routes.draw do
  #
  # === CASTOM JSON ROUTES FOR DEVISE + JWT ===
  #
  devise_for :users,
    defaults: { format: :json },
    skip: :all,  # IMPORTANT !!
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  # Manual JSON routes for API authentication
  devise_scope :user do
    post   "users/sign_in",  to: "users/sessions#create"
    delete "users/sign_out", to: "users/sessions#destroy"

    post   "users",          to: "users/registrations#create"
  end


  #
  # === API NAMESPACE ===
  #
  namespace :api do
    get "/me", to: "me#show"
    resources :items
    resources :orders, only: [:index, :show, :create]
    resources :users
  end
end
