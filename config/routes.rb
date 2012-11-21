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
    resources :sample
  end

  # needs to be changed to something that is not the admin.
  root to: 'admin/sample#index'
end
