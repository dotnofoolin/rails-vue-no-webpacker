Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'frontends#index'

  constraints format: :html do
    resources :frontends, only: [:index]
  end

  constraints format: :json do
    resources :examples, only: [:index]
  end

  # Any unknown path will redirect and let Vue take over.
  get '*path' => 'frontends#index'
end
