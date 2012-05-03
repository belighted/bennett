Bennett::Application.routes.draw do

  devise_for :users
  devise_scope :user do
    get 'login', :to => 'devise/sessions#new'
  end

  resources :projects do
    resources :commands, :except => [:show, :index]
    resources :builds, :only => [:create, :destroy] do
      resources :results, :only => :show
    end
    post 'add_user_or_invite'
  end

  resources :builds, :only => [:index]
  resources :rights, :only => [:update, :destroy]
  resources :invitations, :only => [:update, :destroy]
  resources :users, :only => [:index], :path => 'admins' do
    put :update, on: :collection
  end


  mount Resque::Server, :at => '/resque'

  root :to => 'projects#index'
end
