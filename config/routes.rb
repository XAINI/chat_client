Rails.application.routes.draw do
  
  resources :rooms do
    get :staff, on: :collection
  end
end
