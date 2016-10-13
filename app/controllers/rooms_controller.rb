class RoomsController < ApplicationController
  def index
    
  end

# 注册
  # 将用户保存进数据库中
  def create_participant
    name = params[:name]
    email = params[:email]
    password = params[:password]
    password_digest = params[:password_digest]
    @user = User.new(name: name, email: email, password: password, password_digest: password_digest)
    if @user.save
      redirect_to "/auth"
    else
      render "/rooms/register"
    end
  end

  # 注册
  def register
    
  end

# 讨论组

  # 讨论组列表
  def discussion_group
    user_name = params[:user_name]
    flag = params[:flag]
    @data_group = Group.all.to_a
    @group = []
    if flag == "search"
      if user_name == ""
        redirect_to "/rooms/discussion_group"
      else
        @data_group.each do |g|
          if g.member.include?(user_name)
            @group.push(g)
          end
        end
      end
    end

    if flag == nil
      @data_group.each do |d|
        @group.push(d)
      end
    end
  end

  # 创建讨论组(get)
  def add_group
    @all_user = User.all
  end

  # 创建讨论组(post)
  def create_discussion_group
    group_name = params[:name]
    member = params[:member]
    creator = params[:creator]
    @group = Group.create(:name => group_name, :creator => creator, :member => member)
    if @group.save
      redirect_to "/rooms/discussion_group"
    else
      render json: "创建失败"
    end
  end

  # 修改讨论组信息(get)
  def edit_group
    group_id = params[:id]
    @all_user = User.all
    @group = Group.find(group_id)
  end

  # 修改讨论组信息(post)
  def update_group_member
    member_list = params[:member]
    group_id = params[:group_id]
    flag = params[:flag]
    group_name = params[:group_name]
    creator = params[:creator]
    id = group_id.gsub(/[\n\s]*/, '')

    @group = Group.find(id)

    user_name = @group.creator

    # 用户退出房间 
    if flag == "out"
      member = []
      temp = member_list.gsub(/[\n\s]*/, '')
      member = @group.member
      # 将用户从房间用户列表中移除
      member.each do |m|
        if m == temp
          member.delete(m)
        end
      end
      
      # 将创建者替换成用户列表中第一个用户(如果退出用户为创建者)
      if user_name == temp
        user_name = member[0]
      end

      # 更新房间信息
      if @group.update_attributes(member: member, creator: user_name)
        redirect_to "/rooms/discussion_group"
      else
        render json: "更新失败"
      end
    end

    # 讨论组信息修改(创建者操作)
    if flag == "fix"
      temp_user = ""
      creator == user_name ? temp_user = user_name : temp_user = creator

      if @group.update_attributes(member: member_list, name: group_name, creator: temp_user)
        redirect_to "/rooms/discussion_group"
      else
        render render json: "更新失败"
      end
    end
  end

  # 讨论组聊天室
  def discussion_group_room
    group_id = params[:group_id]
    @group = Group.where(id: group_id).to_a
  end

  # 讨论组详细信息
  def show_detail
    @group = Group.find(params[:id])
  end

  # 保存讨论组离线消息
  def save_group_offline_info
    group_id = params[:group_id]
    sender = params[:sender]
    msg = params[:msg]
    receiver = params[:receiver]
    @group_offline = Message.create(group_id: group_id, sender: sender, msg: msg, receiver: receiver)
    if @group_offline.save
      render json: "消息保存成功"
    else
      render json: "消息保存失败"
    end
  end

  # 获取用户离线消息(讨论组)
  def fetch_group_offline_info
    @group_offline = Message.where(receiver: params[:user]).to_a
    if @group_offline.length == 0
      render json: "讨论组中没有离线消息"
    else
      render json: @group_offline
    end
  end

  # 移除已经显示了的消息
  def remove_group_offline_info
    @group_offline = Message.where(receiver: params[:user])
    @group_offline.each do |ginfo|
      ginfo.destroy
    end

    if @group_offline.to_a.length == 0
      render json: "移除成功"
    end
  end

# 群聊
  # 群组成员
  def staff
    @staff_list = params[:staff_list]
    @user_list = @staff_list.split(',')
    @user_list
  end

  # 群聊房间
  def chat_room
    
  end

# 单聊
  # 显示用户在 select 中
  def private_room
    id = params[:group_id]
    if id != nil
      @group = Group.find(id)
    end
    @user_name_ary = []
    @all_user = User.all.to_a
    @all_user.each do |u|
      @user_name_ary.push(u.name)
    end
  end

  # 保存离线消息
  def save_offline_info
    sender = params[:sender]
    msg = params[:msg]
    receiver = params[:receiver]
    @offline_info = Message.create(sender: sender, msg: msg, receiver: receiver)

    if @offline_info.save
      render json: "对方不在线 信息已保存"
    else
      render json: "对方不在线 信息保存失败"
    end
  end

  # 提取离线消息
  def fetch_offline_info
    user = params[:user]
    @offline_info = Message.where(receiver: user).to_a
    if @offline_info.length == 0
      render json: "没有离线消息"
    else
      render json: @offline_info
    end
  end

  # 移除离线消息
  def remove_offline_info
    user = params[:user]
    @offline_info = Message.where(receiver: user)
    @offline_info.each do |info|
      info.destroy
    end
    if @offline_info.to_a.length == 0
      render json: "移除成功"
    end
  end

end
