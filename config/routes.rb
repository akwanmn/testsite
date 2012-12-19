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

  # needs to be changed to something that is not the admin.
  root to: 'admin/users#index'
end
