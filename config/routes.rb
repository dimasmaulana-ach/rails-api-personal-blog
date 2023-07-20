Rails.application.routes.draw do
  # default_url_options :host => "http://localhost:3000"

  namespace :api do
    namespace :v1 do
      resources :roles
      resources :users, param: :username
      resources :blog_category
      resources :blogs, param: :slug
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
