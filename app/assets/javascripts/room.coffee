class Room
  constructor: (@$eml)->
    @bind_event()

  bind_event: ->
    # jQuery(document).keydown((e)->
      # if e.keyCode == 13
        # into = jQuery('.into').val()
        # label = "<lable style='background: #FFBB5A;'>#{into}</label><br/>"
        # jQuery('.content').append(label)
        # jQuery('.into').val('')
        # jQuery('.content')[0].scrollTop = jQuery('.content')[0].scrollHeight
    # ) 
    @$eml.on 'click', '.type-area .send-msg', ->
      get_time = new Date()
      input_val = jQuery('.into').val() 
      if input_val == ""
        alert("发送内容能为空，请输入发送内容！")
        return
      tag_p = "<p><span style='color: #FFBB5A;'>Iverson</span>&nbsp;&nbsp;&nbsp;&nbsp;#{get_time.toLocaleString()}<br/>&nbsp;&nbsp;&nbsp;&nbsp;#{input_val}</p>"
      jQuery('.content').append(tag_p)
      jQuery('.into').val('')
      jQuery('.content')[0].scrollTop = jQuery('.content')[0].scrollHeight



jQuery(document).on 'turbolinks:load', ->
  if jQuery('.room').length > 0
    new Room jQuery('.room')
