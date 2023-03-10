Rails.application.routes.draw do
  resources :projects do
    resources :comments, only: [:create, :new, :index]
    member do
      get 'history'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "projects#index"
end
