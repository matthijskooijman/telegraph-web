messagesInLast10Seconds = 0
lastMessageType = ""

$ ->
  socket = new WebSocket "ws://#{window.location.host}/chat"

  submitMessage = ($textarea) ->
    socket.send $textarea.val()
    $textarea.val(null)

  socket.onmessage = (event) ->
    if event.data.length
      if /Players said/.test(event.data)
        if lastMessageType != "toSL" || messagesInLast10Seconds == 0
          $("#output").append("<br>")
          $("#output").append "#{event.data}"
        else
          string = event.data.replace(/.*:\s*/, "")
          $("#output").append string

        lastMessageType = "toSL"
        messagesInLast10Seconds++
        setTimeout ->
          messagesInLast10Seconds--
        , 10000
      else
        #lastMessageType = "toPlayers"
        $("#output").append "<br>#{event.data}"

  $("body").on 'keydown', "form textarea", (event) ->
	  if(event.keyCode == 13 && event.metaKey)
      submitMessage $(this)

  $("body").on "submit", "form.message", (event) ->
    event.preventDefault()
    submitMessage $(this).find("textarea")
