class Message < ActiveRecord::Base
  enum direction: [ :toPlayers, :toSL ]

  def to_s
    if toPlayers?
      "<- #{created_at.to_s(:db)} - SL said:      #{content}"
    else
      "-> #{created_at.to_s(:db)} - Players said: #{content}"
    end
  end
end
