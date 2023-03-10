Rails.application.routes.draw do
  resources :projects, only: [:new, :create, :index, :show] do
    resources :comments, only: [:create, :new]
    member do
      get 'new_state_change'
      post 'state_change'
    end
  end

  root "projects#index"
end
