$ ->
  socket = new WebSocket "ws://#{window.location.host}/chat"

  submitMessage = ($textarea) ->
    socket.send $textarea.val()
    $textarea.val(null)

  socket.onmessage = (event) ->
    if event.data.length
      $("#output").append "#{event.data}<br>"

  $("body").on 'keydown', "form textarea", (event) ->
	  if(event.keyCode == 13 && event.metaKey)
      submitMessage $(this)

  $("body").on "submit", "form.message", (event) ->
    event.preventDefault()
    submitMessage $(this).find("textarea")
