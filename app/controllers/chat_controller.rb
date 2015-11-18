class ChatController < ApplicationController
  include Tubesock::Hijack

  def index
    @messages = Message.order(:created_at)
  end

  def chat
    hijack do |tubesock|
      redis_thread = Thread.new do
        Redis.new.subscribe "toSL", "toPlayers" do |on|
          on.message do |channel, message|
            logger.debug("received message: #{message}")

            if channel == "toPlayers"
              tubesock.send_data Message.format(Message.toPlayers.new(content: message))
            else
              tubesock.send_data Message.format(Message.toSL.new(content: message))
            end
          end
        end
      end

      tubesock.onmessage do |m|
        if m !~ /\A\s*\z/
          logger.debug("Sending to players: #{m}")
          Redis.new.publish "toPlayers", m
        end
      end

      tubesock.onclose do
        redis_thread.kill
      end
    end
  end
end
