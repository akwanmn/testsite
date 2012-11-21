Phoenix::Application.routes.draw do
  devise_for :users, path_names: { :sign_in => 'login', :sign_out => 'logout' }
# default urls for user



  ##################################################
  ## ADMIN URLS
  ##################################################
  # the namespace, then the custom path.
  namespace :admin, path: '/super-admin' do 
    resources :sample
  end

  root to: 'sample#index'
end
