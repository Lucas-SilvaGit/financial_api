Rails.application.routes.draw do
  devise_for :users
  
  api_version(:module => 'V1', :path => {:value => 'v1'}) do
    resources :accounts
    resources :entries
    resources :categories

    # route for dashboard
    get '/dashboard/:year/:month', to: 'dashboard#show'
  end
end
