$ ->
  socket = new WebSocket "ws://#{window.location.host}/chat"

  socket.onmessage = (event) ->
    if event.data.length
      $("#output").append "#{event.data}<br>"

  $("body").on "submit", "form.message", (event) ->
    event.preventDefault()
    $input = $(this).find("textarea")
    socket.send $input.val()
    $input.val(null)
