Rails.application.routes.draw do
  
  resources :rooms do
    post :create_participant, on: :collection
    get :staff, on: :collection
    get :chat_room, on: :collection
  end

  mount PlayAuth::Engine => '/auth', :as => :auth
end
