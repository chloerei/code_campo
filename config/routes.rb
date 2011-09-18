CodeCampo::Application.routes.draw do
  root :to => 'homepage#index'

  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'user_sessions#new', :as => :login
  delete 'logout' => 'user_sessions#destroy', :as => :logout
  resources :users, :only => [:create]
  resources :user_sessions, :only => [:create]

  resources :topics
end
