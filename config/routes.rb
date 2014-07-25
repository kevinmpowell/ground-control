require 'sidekiq/web'

MissionControl::Application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, :skip => [:sessions], :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    get 'signin', :to => 'devise/sessions#new', :as => :new_user_session
    post 'signin', :to => 'devise/sessions#create', :as => :user_session
    get 'signout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'application#home'

end
