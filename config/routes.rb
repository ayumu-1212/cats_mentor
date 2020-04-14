Rails.application.routes.draw do
  post '/callback' => 'linebot#receive'
  root to: 'tests#new'
  resources :tests
end
