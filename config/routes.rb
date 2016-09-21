Rails.application.routes.draw do
  
  resources :rooms do
    post :create_participant, on: :collection
    get :staff, on: :collection
    get :chat_room, on: :collection
    get :private_room, on: :collection
    get :register, on: :collection
    get :discussion_group, on: :collection
    get :add_group, on: :collection
    post :create_discussion_group, on: :collection
  end

  mount PlayAuth::Engine => '/auth', :as => :auth
end
