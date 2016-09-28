# 用户注册
class Register
  constructor: (@$eml)->
    @bind_event()

  create_participant: (data)->
    jQuery.ajax
      url: ' /auth/users/developers',
      method: "post",
      data: {name: data}
    .success (msg)->
      console.log msg
    .error (msg)->
      console.log msg


  bind_event: ->
    @$eml.on 'click', '.register-submit-part .submit-name', =>
      name = jQuery('.nickname').val()
      @create_participant(name)

# 聊天室
class Room
  constructor: (@$eml)->
    @bind_event()

  bind_event: ->
    myName = false
    nickname_ary = []
    socket.on 'open', ->
      myDate = new Date()
      name = jQuery('.status').text()
      p = "<p>system  @ #{myDate.toLocaleString()}: Welcome #{name}</p>\n"
      jQuery('.content').append(p)


    socket.on 'system', (json)->
      p = ''
      if json.type == 'disconnect'
        if json.text == false 
          return
        p = "<p style='background: #{json.color}'>system  @ #{json.time} : Bye #{json.text}</p>\n"

      jQuery('.content').append(p)

    socket.on 'message',(json)->
      p = "<p><span style='color: #{json.color};'>#{json.author}</span> @ #{json.time} : #{json.text}</p>"
      jQuery('.content').append(p)
      jQuery('.content')[0].scrollTop = jQuery('.content')[0].scrollHeight

    jQuery('.into').keydown((e)->
      if e.keyCode == 13
        msg = jQuery(this).val()
        name = jQuery('.status').text()
        if !msg
          return
        socket.send(msg, name)
        $(this).val('')
        if myName == false 
          myName = name
    )

    socket.on 'search', (data)->
      console.log "hello"
      window.location.href = "/rooms/staff?staff_list=#{data}"

    jQuery('.room-staff .staff').click ->
      name = jQuery('.status').text()
      socket.emit("add user", name)
        

# 单聊
class PrivateRoom
  constructor: (@$eml)->
    @bind_event()

  bind_event: ->
    jQuery('.private-send .send-message').click ->
      from = jQuery('.private-input .from-name').val()
      msg = jQuery('.private-input .message').val()
      to = jQuery('.private-input .to-name').val()
      message_list = jQuery('.private-content')
      if from != '' && msg != '' && to != '0'
        socket.emit('new user', from, to)
        socket.emit('private message', from, to, msg)
        socket.on "to#{from}", (data)->
          message_list.append("<p><strong>#{data.from}:&nbsp;&nbsp;&nbsp;&nbsp;</strong>#{data.mess}</p>")
          message_list[0].scrollTop = message_list[0].scrollHeight

        jQuery('.private-input .message').val('')


# 讨论组列表
class DiscussionGroupList
  constructor: (@$eml)->
    @bind_event()

  bind_event: ->
    # 点击讨论组名称，进入讨论组
    @$eml.on 'click', ".group-list .group-names .name", ->
      members = jQuery(this).closest('.name').attr('data-members')
      current_user = jQuery(this).closest('.name').attr('data-current-user')
      group_id = jQuery(this).closest('.name').attr('data-group-id')
      temp = JSON.parse(members)
      boolean = jQuery.inArray(current_user, temp)
      if boolean == -1
        alert("您还不在讨论组中请与创建者联系申请加入本讨论组")
      else
        window.location.href = "/rooms/discussion_group_room?group_id=#{group_id}"

    # 点击修改进入修改界面
    @$eml.on 'click', '.group-list .group-names .edit--discussion-group', ->
      creator = jQuery(this).closest('.edit--discussion-group').attr('data-creator')
      current_user = jQuery(this).closest('.edit--discussion-group').attr('data-current-user')
      group_id = jQuery(this).closest('.edit--discussion-group').attr('data-group-id')
      if creator == current_user
        window.location.href = "/rooms/#{group_id}/edit_group"
      else
        alert("您不是创建者不能对讨论组信息进行修改")
        

# 创建讨论组
class AdddDiscussionGroup
  constructor: (@$eml)->
    @bind_event()

  create_group: (group_name, members, current_user)->
    jQuery.ajax
      url: "/rooms/create_discussion_group",
      method: "post",
      data:{name: group_name, member: members, creator: current_user}
    .success (msg)->
      alert("success")
      console.log msg
    .error (msg)->
      console.log msg

  bind_event: ->
    @$eml.on 'click', '.submit-checked .create-group', =>
      participant = ""
      group_name = jQuery('.group-name').val()
      current_user = jQuery('.title .current-user').text()
      jQuery("input[name='checkbox']:checked").each ->
        participant += "#{jQuery(this).val()},"

      if group_name != '' && participant.length != '' && current_user != ''
        @create_group(group_name, participant, current_user)


# 修改讨论组信息
class DiscussionGroupEdit
  constructor: (@$eml)->
    @bind_event()

  update_group_detail: (name, member, creator, id, flag)->
    jQuery.ajax
      url: "/rooms/update_group_member",
      method: "post",
      data: {group_name: name, group_id: id, member: member, flag: flag, creator: creator}
    .success (msg)->
      console.log msg
    .error (msg)->
      console.log msg

  bind_event: ->
    @$eml.on 'click', '.submit-checked .create-group', =>
      group_name = jQuery('.all-user-list .group-name .input-name').val()
      current_user = jQuery('.title .current-user').text()
      group_id = jQuery('.submit-checked .hidden-tag .span-val').text()
      user_name = current_user.replace(/[\n\s]/g, '')
      member = []
      flag = "fix"
      jQuery("input[name='checkbox']:checked").each ->
        member.push(jQuery(this).val())

      if member.indexOf(user_name) > -1
        @update_group_detail(group_name, member, user_name, group_id, flag)
      else if confirm("您确定要将创建者移除吗？")
        user_name = member[0]
        @update_group_detail(group_name, member, user_name, group_id, flag)
      else
        console.log "取消"



# 讨论组房间
class DiscussionGroupRoom
  constructor: (@$eml)->
    @bind_event()


  out_discussion_group: (data, id, flag)->
    jQuery.ajax
      url: "/rooms/update_group_member",
      method: "post",
      data: {member: data, group_id: id, flag: flag}
    .success (msg)->
      socket.emit('leave')
      console.log msg
    .error (msg)->
      console.log msg


  bind_event: ->
    user_name = jQuery('.send-discussion-msg .group-name').text()
    # 加入房间
    socket.on 'connect', ->
      socket.emit('join', user_name)

    # 监听消息
    socket.on 'msg', (user_name, msg)->
      message = "<p>#{user_name}: #{msg}</p>"
      jQuery('.discussion-content').append(message)
      jQuery('.discussion-content')[0].scrollTop = jQuery('.discussion-content')[0].scrollHeight

    # 监听系统消息
    socket.on 'sys', (sys_msg, users)->
      message = "<p>#{sys_msg}</p>"
      jQuery('.discussion-content').append(message)
      jQuery('.discussion-content')[0].scrollTop = jQuery('.discussion-content')[0].scrollHeight

    # 发送消息
    jQuery('.send-discussion-msg .send').click ->
      msg = jQuery('.send-discussion-msg .input-msg').val()
      jQuery('.send-discussion-msg .input-msg').val('')
      socket.send(msg)

    # 退出房间
    jQuery('.discussion-group-name .out-group').click =>
      group_id = jQuery(".discussion-group-name .group-name-msg .group-id").text()
      flag = "out"
      @out_discussion_group(user_name, group_id, flag)


# 讨论组列表
class GroupList
  constructor: (@$eml)->
    @bind_event()


  bind_event: ->
    @$eml.on 'click', '.group-list .list-head .search-group', =>
      user_name = jQuery('.input-into').val()
      # if user_name == ''
      #   alert('请输入用户名')
      # else
      window.location.href = "/rooms/discussion_group?user_name=#{user_name}&flag=search"



# 群聊天室
jQuery(document).on 'ready page:load', ->
  if jQuery('.room').length > 0
    new Room jQuery('.room')

# 用户注册
jQuery(document).on 'ready page:load', ->
  if jQuery('.register').length > 0
    new Register jQuery('.register')

# 单聊
jQuery(document).on 'ready page:load', ->
  if jQuery('.private-room').length > 0
    new PrivateRoom jQuery('.private-room')

# 讨论组
jQuery(document).on 'ready page:load', ->
  if jQuery('.add-group').length > 0
    new AdddDiscussionGroup jQuery('.add-group')

# 讨论组列表
jQuery(document).on "ready page:load", ->
  if jQuery('.group').length > 0
    new DiscussionGroupList jQuery('.group')

# 讨论组房间
jQuery(document).on "ready page:load", ->
  if jQuery('.discussion-room').length > 0
    new DiscussionGroupRoom jQuery('.discussion-room')

# 修改讨论组信息
jQuery(document).on 'ready page:load', ->
  if jQuery('.edit-group').length > 0
    new DiscussionGroupEdit jQuery('.edit-group')

# 讨论组列表
jQuery(document).on 'ready page:load', ->
  if jQuery('.group').length > 0
    new GroupList jQuery('.group')

