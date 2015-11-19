#!/usr/bin/env ruby

ENV['RAILS_ENV'] ||= 'production'

require 'optparse'
require 'redis'
require 'rubyserial'

require_relative 'config/environment'

address = '/dev/cu.usbmodem1421'
baudrate = 115200 

OptionParser.new do |opts|
  opts.banner = "Usage: ./#{$0} [options]"

  opts.on("-a", "--address ADDRESS", "Specify device address") do |a|
    address = a
  end
end.parse!

puts "opening #{address}"
$device = Serial.new(address, baudrate)

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

    puts "entering run loop"
    while(true)
      message = $device.read(100)

      if message != ""
        puts "Received from device: #{message}"

        Message.toSL.create_or_append(message)

        Redis.new.publish("toSL", message)
      end
    end
  end
end

PubSubSerial.run
