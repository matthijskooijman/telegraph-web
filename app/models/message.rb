class Message < ActiveRecord::Base
  enum direction: [ :toPlayers, :toSL ]

  def to_s
    if toPlayers?
      "<- #{created_at} SL said:      #{content}"
    else
      "-> #{created_at} Players said: #{content}"
    end
  end
end
