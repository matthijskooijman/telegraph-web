class Message < ActiveRecord::Base
  enum direction: [ :toPlayers, :toSL ]

  @timespan_between_messages = 5.seconds

  def self.create_or_append(text)
    latest = last

    if latest && latest.updated_at > @timespan_between_messages.ago
      latest.update_attribute(:content, latest.content + text)
    else
      create(content: text)
    end
  end

  def to_s
    if toPlayers?
      "<- #{created_at.to_s(:db)} - SL said:      #{content}"
    else
      "-> #{created_at.to_s(:db)} - Players said: #{content}"
    end
  end
end
