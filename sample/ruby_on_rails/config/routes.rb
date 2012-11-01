EvernoteSample::Application.routes.draw do
  root :to => 'home#index'

  get '/modes/switch' => 'home#switch_mode', :as => 'switch_mode'

  get '/auth/:provider/callback' => 'login#callback'
  get '/logout' => 'login#logout', :as => 'logout'
  get '/oauth_failure' => 'login#oauth_failure'

  get 'user_store/:method' => 'user_store#call', :as => 'user_store'
  get 'note_store/:method' => 'note_store#call', :as => 'note_store'
  get 'advanced/:method' => 'advanced#call', :as => 'advanced'
end
