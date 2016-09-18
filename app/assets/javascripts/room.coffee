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
      socket.emit("open", name)
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

    socket.on 'search', (data)->
      nickname_ary = data

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

    @$eml.on 'click', '.room-staff .staff', ->
      window.location.href = "/rooms/staff?staff_list=#{nickname_ary}"


class PrivateRoom
  constructor: (@$eml)->
    @bind_event()

  bind_event: ->
    name = jQuery('.private-input .from-name').val()
    socket.emit('userAry', name)

    jQuery('.private-input .to-name').click (e)->
      re = /["]*/
      user = jQuery(this).attr("data-users")
      temp = user.replace('\[','')
      temp_ary = temp.replace('\]','')
      temp_list = temp_ary.replace(re,'')
      user_ary = temp_list.split(',')
      console.log user_ary
      if jQuery(this).text() != ''

      else
        jQuery(this).prepend("<option value='0'>请选择</option>")
        jQuery(this).append("<option value=''>Text</option>")
      # socket.on 'privtNmAry', (data)->
        # for name in data
        #   console.log name

        # jQuery(this).prepend("<option value='0'>请选择</option>")
        # jQuery(this).append("<option value=''>Text</option>")

    jQuery('.private-send .send-message').click((e)->
      from = jQuery('.private-input .from-name').val()
      msg = jQuery('.private-input .message').val()
      to = jQuery('.private-input .to-name').val()
      message_list = jQuery('.private-content')
      if from == '' || msg == '' || to == ''

      else 
        socket.emit('new user', from)
        socket.emit('private message', from, to, msg)
        socket.on "to#{from}", (data)->
          message_list.append("<p><strong>#{data.from}:&nbsp;&nbsp;&nbsp;&nbsp;</strong>#{data.mess}</p>")
          message_list[0].scrollTop = message_list[0].scrollHeight

        jQuery('.private-input .message').val('')
    )


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
