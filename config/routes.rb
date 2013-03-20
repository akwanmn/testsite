Phoenix::Application.routes.draw do
  ##################################################
  # GLOBAL ROUTES
  ##################################################
  devise_for :users, path_names: { :sign_in => 'login', :sign_out => 'logout' },
    controllers: {sessions: 'lounge/sessions'}

  ##################################################
  ## ADMIN URLS
  ##################################################
  # the namespace, then the custom path.
  namespace :admin, path: '/super-admin' do
    match '/orders/latest' => 'orders#latest'
    match '/' => 'users#index'
    resources :sample
    resources :subscriptions
    resources :users do
      resources :photos, :except => [:update, :edit]
      member do
        get :disable
        get :restore
        put :update_profile
        get :edit_profile
      end
      collection do
        get :search
      end
      resources :orders do
        member do
          put :refund
        end
      end
    end
  end

  # Lounge URLS
  namespace :lounge, path: '/' do
    resources :home, only: [:new]
    match '/signup' => 'home#signup', via: :post
    resources :dashboard, only: [:index] do
      collection do
        match 'search' => 'dashboard#search', via: :post
      end
    end
    resources :profile
    resources :user do
      resources :photos
    end
  end

  #resources :home, :only => [:index, :new, :create]
  #resources :users

  # needs to be changed to something that is not the admin.
  root to: 'lounge/home#new'
end
