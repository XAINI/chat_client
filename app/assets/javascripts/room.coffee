class Room
  constructor: (@$eml)->
    @bind_event()

  bind_event: ->
    myName = false
    socket.on 'open', ->
      jQuery('.status').text('输入昵称:')

    socket.on 'system', (json)->
      p = ''
      if json.type == 'welcome' 
        if myName == json.text
          jQuery('.status').text(myName + ': ').css('color', json.color)
        p = "<p style='background: #{json.color}'>system  @ #{json.time}: Welcome #{json.text}</p>\n"

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
        if !msg
          return
        socket.send(msg)
        $(this).val('')
        if myName == false 
          myName = msg
    )

    @$eml.on 'click', '.room-staff .staff', ->
      console.log name_ary
      
    # @$eml.on 'click', '.type-area .send-msg', ->
    #   get_time = new Date()
    #   input_val = jQuery('.into').val() 
    #   if input_val == ""
    #     alert("发送内容能为空，请输入发送内容！")
    #     return
    #   tag_p = "<p><span style='color: #FFBB5A;'>Iverson</span>&nbsp;&nbsp;&nbsp;&nbsp;#{get_time.toLocaleString()}<br/>&nbsp;&nbsp;&nbsp;&nbsp;#{input_val}</p>"
    #   jQuery('.content').append(tag_p)
    #   jQuery('.into').val('')
    #   jQuery('.content')[0].scrollTop = jQuery('.content')[0].scrollHeight



jQuery(document).on 'ready page:load', ->
  if jQuery('.room').length > 0
    new Room jQuery('.room')
