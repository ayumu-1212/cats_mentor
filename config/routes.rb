Rails.application.routes.draw do
  post '/callback' => 'linebot#receive'
  root to: 'tests#new'
  resources :tests, only: [:new, :create, :show] do
    collection do
      post :mentor_create
      get :mentor_show
    end
  end
end
