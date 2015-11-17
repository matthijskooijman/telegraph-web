class ChatController < ApplicationController
  include Tubesock::Hijack

  def chat
    hijack do |tubesock|
      redis_thread = Thread.new do
        Redis.new.subscribe "toSL", "toPlayers" do |on|
          on.message do |channel, message|
            logger.debug("received message: #{message}")

            tubesock.send_data message
          end
        end
      end

      tubesock.onmessage do |m|
        if m !~ /\A\s*\z/
          begin
            Message.create! do |message|
              message.content = m
            end
          rescue Exception => e
            logger.fatal e
          end

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
