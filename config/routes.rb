require 'sidekiq/web'

GroundControl::Application.routes.draw do
  resources :client_repos
  resources :issues, only: [:index, :show, :update]

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, :skip => [:sessions], :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    get 'signin', :to => 'devise/sessions#new', :as => :new_user_session
    post 'signin', :to => 'devise/sessions#create', :as => :user_session
    get 'signout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  put 'synchronize-github-issues-for-user/:user_id', :to => 'github_service#synchronize_github_issues'
  put 'complete_github_sync_for_user/:user_id', :to => 'github_syncs#complete_github_sync_for_user'
  get 'last_github_sync_for_user/:user_id', :to => 'github_syncs#last_github_sync_for_user', :format => :json
  put 'update-issue-sort-order', :to => 'issues#update_issue_sort_order', :format => :json

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'application#angular_app'

   get "/*path" => "application#angular_app"

end
