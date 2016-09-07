Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations',  }
  root 'home#index'
  get '/home' => 'home#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
