class RoomsController < ApplicationController
  def index
    
  end

# 注册
  # 将用户保存进数据库中
  def create_participant
    
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

end
