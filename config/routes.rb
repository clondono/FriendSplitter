Friendsplitter::Application.routes.draw do

  get "authentication/index"
  get "authentication/create"
  get "authentication/destroy"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'

  resources :debts, only: [:update]
  resources :contributions do
    member do
      get :approve
      get :decline
    end
  end
  resources :events, only: [:new, :create, :show]

  put 'debts/pay' => 'debts#pay'

  #redirect all non-recognized paths to root
  match '*path', to: redirect('/'), via: 'get'

end
