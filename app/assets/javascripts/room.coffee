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
        socket.emit('new user', from)
        socket.emit('private message', from, to, msg)
        socket.on "to#{from}", (data)->
          console.log "Hi your in"
          message_list.append("<p><strong>#{data.from}:&nbsp;&nbsp;&nbsp;&nbsp;</strong>#{data.mess}</p>")
          console.log "emit message successed"
          message_list[0].scrollTop = message_list[0].scrollHeight

        jQuery('.private-input .message').val('')


# 讨论组列表
class DiscussionGroupList
  constructor: (@$eml)->
    @bind_event()

  bind_event: ->
    @$eml.on 'click', ".group-list .group-names .name", ->
      group_id = jQuery(this).closest('.name').attr('data-group-id')
      window.location.href = "/rooms/discussion_group_room?group_id=#{group_id}"

# 讨论组
class DiscussionGroup
  constructor: (@$eml)->
    @bind_event()

  create_group: (group_name, members)->
    jQuery.ajax
      url: "/rooms/create_discussion_group",
      method: "post",
      data:{name: group_name, member: members}
    .success (msg)->
      alert("success")
      console.log msg
    .error (msg)->
      console.log msg

  bind_event: ->
    @$eml.on 'click', '.submit-checked .create-group', =>
      participant = ""
      group_name = jQuery('.group-name').val()
      jQuery("input[name='checkbox']:checked").each ->
        participant += "#{jQuery(this).val()},"

      if group_name != '' && participant.length != ''
        @create_group(group_name, participant)

# 讨论组房间
class DiscussionGroupRoom
  constructor: (@$eml)->
    @bind_event()


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

    # 发送消息
    jQuery('.send-discussion-msg .send').click ->
      msg = jQuery('.send-discussion-msg .input-msg').val()
      jQuery('.send-discussion-msg .input-msg').val('')
      socket.send(msg)

    # 退出房间
    jQuery('.discussion-group-name .out-group').click ->
      socket.emit('leave')





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
    new DiscussionGroup jQuery('.add-group')

# 讨论组列表
jQuery(document).on "ready page:load", ->
  if jQuery('.group').length > 0
    new DiscussionGroupList jQuery('.group')

# 讨论组房间
jQuery(document).on "ready page:load", ->
  if jQuery('.discussion-room').length > 0
    new DiscussionGroupRoom jQuery('.discussion-room')
  

