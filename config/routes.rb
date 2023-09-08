Rails.application.routes.draw do
  api_version(:module => 'V1', :path => {:value => 'v1'}) do
    resources :accounts
  end

  resources :entries
  resources :categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
