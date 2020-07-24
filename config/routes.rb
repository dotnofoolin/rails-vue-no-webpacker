Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'examples#index'

  constraints format: :json do
    resources :examples, only: [:index]
  end

  get '*path' => 'examples#index'
end
