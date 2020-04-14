Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  Rails.application.routes.draw do  
    post '/callback' => 'linebot#callback'
  end
  root to: 'tests#new'
end
