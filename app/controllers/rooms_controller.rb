class RoomsController < ApplicationController
  def index
    
  end

  # 将用户保存进数据库中
  def create_participant
    
  end

  # 注册
  def register
    
  end

  # 讨论组
  def discussion_group
    @group = Group.all
  end

  # 添加讨论组的界面
  def add_group
    @all_user = User.all
  end

  # 创建讨论组
  def create_discussion_group
    group_name = params[:name]
    member = params[:member]
    creator = params[:creator]
    member_ary = member.split(',')
    @group = Group.create(:name => group_name, :creator => creator, :member => member_ary)
    if @group.save
      redirect_to "/rooms/discussion_group"
    else
      render json: "创建失败"
    end
  end

  # 更新讨论组成员名单
  def update_group_member
    member_list = params[:member]
    temp = member_list.gsub(/[\n\s]*/, '')
    
    p ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    p temp
    p ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  end

  # 讨论组房间
  def discussion_group_room
    group_id = params[:group_id]
    @group = Group.where(id: group_id).to_a
    @group
  end

  # 群组成员
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
    @user_name_ary = []
    @all_user = User.all.to_a
    @all_user.each do |u|
      @user_name_ary.push(u.name)
    end
    @user_name_ary
  end

end
