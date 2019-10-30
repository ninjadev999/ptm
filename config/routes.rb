# frozen_string_literal: true

require 'route_constraints'
require "sidekiq/web"

Sidekiq::Web.set :session_secret, ENV["SECRET_KEY_BASE"]

Rails.application.routes.draw do

  mount ActionCable.server => "/cable"

  # Admin routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticate :admin_user do
    mount Sidekiq::Web => "/sidekiq"
  end

  # General host/guest routes
  devise_for :users, controllers: { registrations: "registrations" }
  resource :preferences, only: [:show, :update] do
    put :update_password
    scope module: :preferences do
      resource :plans do
        get :host_plan, on: :collection
        put :update_host_plan, on: :member
      end
      resource :settings
    end
  end
  resources :topics, only: [:index]
  resources :promotions, only: [:index]
  resources :credit_cards, only: [:index, :create, :destroy]

  resources :podcast_invites, except: [:index] do
    member do
      post :resend
      put :confirm
      put :decline
    end
  end

  resources :invites, except: [:index] do
    member do
      post :resend
      put :confirm
      put :decline
    end
  end

  resources :profiles do
    get :autocomplete_promotion_name, :on => :collection
    get :autocomplete_topic_name, :on => :collection
    get :autocomplete_expertise_name, :on => :collection
    get :autocomplete_profile_primary_industry, :on => :collection
  end

  resources :switch_roles, only: :create

  resources :guests

  # Host routes
  constraints(HostRoutes) do
    authenticated :user do
      resources :accounts do
        member do
          get "select" => "accounts#select"
          put "update_social_url" => "accounts#update_social_url"
        end
      end

      namespace :current_account, path: "account" do
        root to: "base#root"
        resources :invoices, only: [:index, :show, :update]
        resource :subscription
      end

      resources :orders do
        member do
          match :setup, via: [:get, :post]
        end
      end
      resources :order_wizards
      resources :addresses

      resources :interviews, only: [:index] do
        resources :recordings, only: [:show]
        resources :guests, module: :interviews do
          post :invite
        end

        # For solicited interviews
        get :search,  on: :collection
        post :apply
        get :see_detail

        collection do
          get :selector
          get :hardware_selection
        end
        member do
          get :gateway
          put :launch
        end
      end

      post '/rate' => 'rater#create', :as => 'rate'

      get "/checkout/checkout", to: "checkout#checkout", as: "checkout"
      post "/checkout/purchase", to: "checkout#purchase", as: "purchase"
      post "/checkout/purchase_addon_seats", to: "checkout#purchase_addon_seats", as: "purchase_addon_seats"
      post "/checkout/purchase_bundle", to: "checkout#purchase_bundle", as: "purchase_bundle"
      get "/checkout/total", to: "checkout#total", as: "checkout_total"
    end
  end

  # Host Routes
  scope module: :hostuser do
    resources :host_account_setups, only: [] do
      collection do
        get :set_password
        post :create_account

        get :choose_plan
        put :select_plan

        get :checkout
        post :purchase

        get :buy_interview
        put :select_bundle

        get :checkout_interview
        post :purchase_bundle

      end
    end
  end

  # Guest routes

  scope module: :guest do
    resources :account_setups, only: [] do
      collection do
        get :set_password
        post :create_account
        get :choose_plan
        put :select_plan
        get :settings
        put :settings
        get :preview
        get :checkout
        post :purchase
      end
    end
  end

  constraints(GuestRoutes) do
    authenticated :user do
      scope module: :guest do
        resources :invites, only: [:index, :show]
        # resources :podcast_invites, only: [:index, :show]

        resources :subscriptions, only: [:create, :destroy]
        resources :interviews, only: [:index, :show, :new] do
          resources :accounts, module: :interviews do
            post :invite
          end
          get :search,  on: :collection
          post :apply
          get :show_account
          get :see_detail
        end
        get :profile, to: 'profiles#show', as: :my_profile
      end
      post '/rate' => 'rater#create', :as => 'rate_host'
    end
  end

  resources :public_sites
  resources :social_sites
  resources :account_public_sites
  resources :account_social_sites


  authenticated :user do
    resources :interviews, only: [:new, :create, :show, :edit, :update]
  end
  devise_scope :user do
    get "/auth/:action/callback", :controller => "authentications", :constraints => { :action => /linkedin|facebook/ }
  end

  # Authenticated/Unauthenticated/Shared routes
  get "/interviews/:id/live", to: "interviews#live", as: "live_interview"
  get "/interviews/:id/live_room_html", to: "interviews#live_room_html", as: "live_room_html"
  get "/interviews/:id/prep", to: "interviews#prep", as: "prep_interview"
  get "/interviews/:id/audiovisual_check", to: "interviews#audiovisual_check", as: "audiovisual_check"
  post "/interviews/:id/create_track_sid", to: "interviews#create_track_sid", as: "interview_create_track_sid"

  get "/zoho", to: "zoho#index", as: "zoho_process"

  # Unauthenticated routes
  root to: "site/pages#root"

  get "/interviews/:id/waiting_room", to: "interviews#waiting_room", as: "waiting_room"

  # Public profile routes
  get "/public/accounts/:id", to: "accounts#show_public_account", as: "show_public_account"
  get "/public/profiles/:id", to: "guest/profiles#show_public_profile", as: "show_public_profile"

  get 'privacy_policy', to: 'site/pages#privacy_policy'
  get 'terms', to: 'site/pages#terms'

  post "/twilio/events", to: "twilio#events"
  post "/twilio/prep_events", to: "twilio#prep_events"
  post "/twilio/receive"
  post "/stripe/receive"
  get "/users/choose_type", to: "pre_register#choose_type", as: "choose_type"

  get '*path', to: redirect('/users/sign_in'), constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }
end
