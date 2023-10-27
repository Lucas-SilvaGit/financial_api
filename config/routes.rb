Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  api_version(:module => 'V1', :path => {:value => 'v1'}) do
    resources :accounts
    resources :entries
    resources :categories

    # route for dashboard
    get '/dashboard/:year/:month', to: 'dashboard#show'
  end
end
