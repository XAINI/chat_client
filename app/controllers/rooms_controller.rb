class RoomsController < ApplicationController
  def index
    
  end

  # 将用户保存进数据库中
  def create_participant
    
  end


  def staff
    @staff_list = params[:staff_list]
    @user_list = @staff_list.split(',')
    @user_list
  end

  # 群聊
  def chat_room
    
  end

  # 单聊
  def private_room
    
  end
end
