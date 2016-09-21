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
  

