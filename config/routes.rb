Phoenix::Application.routes.draw do
  ##################################################
  # GLOBAL ROUTES
  ##################################################
  devise_for :users, path_names: { :sign_in => 'login', :sign_out => 'logout' }


  ##################################################
  ## ADMIN URLS
  ##################################################
  # the namespace, then the custom path.
  namespace :admin, path: '/super-admin' do 
    match '/orders/latest' => 'orders#latest'
    resources :sample
    resources :subscriptions
    resources :users do 
      member do
        get :disable
        get :restore
      end
      resources :orders do
        member do 
          put :refund
        end
      end
    end
  end

  # needs to be changed to something that is not the admin.
  root to: 'admin/users#index'
end
