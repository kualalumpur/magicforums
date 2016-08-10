Rails.application.routes.draw do

  root to: 'landing#index'
  get :about, to: 'static_pages#about'
  resources :topics, except: [:show] do
    resources :posts, except: [:show] do
      resources :comments, except: [:show]
    end
  end
  resources :users, only: [:new, :edit, :create, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]


  # get :resetpassword, to: 'password_resets#new'
  # post :password_resets, to: 'password_resets#edit'
  # patch :password_reset, to: 'password_resets#update'

  get :testindex, to: 'landing#testindex' # terrence's testing
  get :test, to: 'test#testing' # terrence's testing
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
