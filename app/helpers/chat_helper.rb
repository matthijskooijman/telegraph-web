module ChatHelper
  def preformat(message)
    if message.toPlayers?
      prefix = "<- #{message.created_at.to_s(:db)} - SL said:      "
    else
      prefix = "-> #{message.created_at.to_s(:db)} - Players said: "
    end

    spacer = "\n" + " " * prefix.length
    (prefix + message.content.gsub(/\n/, spacer)).html_safe
  end
end

