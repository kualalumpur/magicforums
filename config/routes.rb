Rails.application.routes.draw do

  root to: 'landing#index'
  get :about, to: 'static_pages#about'
  resources :topics, except: [:show] do
    resources :posts, except: [:show]
  end

  get :testindex, to: 'landing#testindex' # terrence's testing
  get :test, to: 'test#testing' # terrence's testing
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
