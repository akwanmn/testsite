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
  namespace :lounge, path: '/lounge' do
    resources :home, only: [:new]
    match '/signup' => 'home#signup', via: :post
    resources :dashboard, only: [:index] do
      collection do
        match 'search' => 'dashboard#search', via: :post
      end
    end
    resources :profile, constraints: {:id => /[\w.-@]+?/, :format => /html|csv/}, only: [:edit, :update, :show] do
      #match "profile/:id" => "profile#show", :constraints => {:id => /[\w.]+?/, :format => /html|csv/}
      #resources :feeds, :id => /[A-Za-z0-9\.]+?/, :format => /json|csv|xml|yaml/
      collection do
        get 'modify' => 'profile#edit'
      end
    end
    resources :user, except: [:index, :new, :create, :edit, :update, :delete] do
      resources :photos, only: [:index, :create, :destroy]
    end
    resources :messages, only: [:index, :show, :create] do
      collection do
        get 'trash' => 'messages#trash'
        get 'archives' => 'messages#archives'
        get 'sent' => 'messages#sent'
        post 'ping' => 'messages#ping'
      end
      member do
        get 'view' => 'messages#view'
        post 'archive' => 'messages#archive_communications'
        post 'delete' => 'messages#delete_communications'
      end
    end
  end

  get 'faq'       => 'lounge/static#faq'
  get 'terms'     => 'lounge/static#terms'
  get 'tips'      => 'lounge/static#tips'
  get 'articles'  => 'lounge/static#articles'
  get 'success'   => 'lounge/static#success'
  get 'privacy'   => 'lounge/static#privacy'


  #resources :home, :only => [:index, :new, :create]
  #resources :users

  # needs to be changed to something that is not the admin.
  root to: 'lounge/home#new'
end
