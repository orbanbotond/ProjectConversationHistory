Rails.application.routes.draw do
  resources :projects, only: [:new, :create, :index, :show] do
    resources :comments, only: [:create, :new]
  end

  root "projects#index"
end
