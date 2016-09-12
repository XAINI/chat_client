# 用户注册
class Register
  constructor: (@$eml)->
    @bind_event()

  create_participant: (data)->

  bind_event: ->
    # jQuery('.nickename').keydown((e)=>
    #   if e.keyCode == 13
    #     name = jQuery(this).val()
    #     @create_participant(name)
    # )

    @$eml.on 'click', '.register-submit-part .submit-name', =>
      name = jQuery('.nickename').val()
      @create_participant(name)

# 聊天室
class Room
  constructor: (@$eml)->
    @bind_event()

  bind_event: ->
    myName = false
    nickname = []
    socket.on 'open', ->
      myDate = new Date()
      name = jQuery('.status').text()
      p = "<p>system  @ #{myDate.toLocaleString()}: Welcome #{name}</p>\n"
      jQuery('.content').append(p)


    socket.on 'system', (json)->
      p = ''
      # if json.type == 'welcome'
      #   if myName == json.text
      #     jQuery('.status').text(myName + ': ').css('color', json.color)
      #   p = "<p style='background: #{json.color}'>system  @ #{json.time}: Welcome #{json.text}</p>\n"

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
      nickname = data

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
      window.location.href = "/rooms/staff?staff_list=#{nickname}"


# 聊天室
jQuery(document).on 'ready page:load', ->
  if jQuery('.room').length > 0
    new Room jQuery('.room')

# 用户注册
jQuery(document).on 'ready page:load',->
  if jQuery('.register').length > 0
    new Register jQuery('.register')
