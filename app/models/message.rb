class Message < ActiveRecord::Base
  enum direction: [ :toPlayers, :toSL ]

  def to_s
    self.class.format(self)
  end

  def self.format(message)
    if message.toPlayers?
      "<- SL said:      #{message.content}"
    else
      "-> Players said: #{message.content}"
    end
  end
end
