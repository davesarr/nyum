Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations',  }
  root 'home#index'
  get '/restaurants' => 'restaurants#index'

  resources :restaurants do
    member do
      put "like", to: "restaurants#upvote"
      put "dislike", to: "restaurants#downvote"
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
