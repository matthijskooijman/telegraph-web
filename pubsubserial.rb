ENV['RAILS_ENV'] ||= 'production'

require 'redis'
require 'rubyserial'

require_relative 'config/environment'

addr = '/dev/tty.usbmodem1411'
baudrate = 57600

$device = Serial.new(addr, baudrate)

class PubSubSerial
  def self.run
    Thread.new do
      Redis.new.subscribe "toPlayers" do |on|
        on.message do |channel, message|
          Message.toPlayers.create do |m|
            m.content = message
          end

          puts "Sending to device: #{message}"

          $device.write message
        end
      end
    end

    while(true)
      message = $device.read(100)

      if message != ""
        puts "Received from device: #{message}"

        Message.toSL.create do |m|
          m.content = message
        end

        Redis.new.publish("toSL", message)
      end
    end
  end
end

PubSubSerial.run
