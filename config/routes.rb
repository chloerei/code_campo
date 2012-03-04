CodeCampo::Application.routes.draw do
  root :to => 'homepage#index'

  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'user_sessions#new', :as => :login
  delete 'logout' => 'user_sessions#destroy', :as => :logout
  resources :users, :only => [:create]
  resources :user_sessions, :only => [:create]

  resource :search, :controller => 'search', :only => 'show'

  get '~:name', :controller => 'people', :action => 'show', :as => :person
  resources :notifications, :only => [:index, :destroy] do
    collection do
      put :mark_all_as_read
    end
  end
  resources :topics, :only => [:index, :show, :new, :create, :edit, :update] do
    collection do
      get :newest
      get :my
      get :marked
      get :replied
      get 'tagged/:tag', :action => 'tagged', :as => :tagged, :constraints  => { :tag => /[^\/]+/ }, :format => false
      get :interesting
    end
    member do
      post :mark
      delete :mark, :action => 'unmark'
    end
  end
  resources :replies, :only => [:new, :create, :edit, :update]
  namespace :settings do
    resource :account, :only => [:show, :update]
    resource :password, :only => [:show, :update]
    resource :profile, :only => [:show, :update]
    resources :favorite_tags, :only => [:index, :create, :update, :destroy], :constraints => {:id => /[^\/]+/}
  end

  namespace :admin do
    resources :users, :only => [:index, :show, :destroy]
  end
end
