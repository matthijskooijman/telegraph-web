class Message < ActiveRecord::Base
  enum direction: [ :toPlayers, :toSL ]
end
