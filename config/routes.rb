Rails.application.routes.draw do
  
  resources :rooms do
    # 群聊
    get :staff, on: :collection
    get :chat_room, on: :collection
    # 私聊
    get :private_room, on: :collection
    # 注册
    get :register, on: :collection
    post :create_participant, on: :collection
    # 讨论组
    get :discussion_group, on: :collection
    get :add_group, on: :collection
    post :create_discussion_group, on: :collection
    get :discussion_group_room, on: :collection
    post :update_group_member, on: :collection
  end

  mount PlayAuth::Engine => '/auth', :as => :auth
end
