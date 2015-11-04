require 'rubyserial'
require 'optparse'
require 'redis'

$debug = false
OptionParser.new do |opts|
  opts.banner = "Usage: ./#{$0} [$options]"

  opts.on("-d", "--debug") do |f|
    $debug = true
  end
end.parse!

if $debug
  $output = $stdout
  $input = $stdin
else
  $output = Serial.new(@device, @baudrate)
  $input = $output
end

class PubSubSerial
  @device = '/dev/tty.usbmodem1411'
  @baudrate = 57600

  def self.run
    Thread.new do 
      Redis.new.subscribe "toPlayers" do |on|
        on.message do |channel, message|
          # TODO: write to device
          $output.puts message
        end
      end
    end

    while(true)
      # TODO: read from device
      message = $input.gets.chomp

      if $debug
        puts message
      end

      Redis.new.publish("toSL", message)
    end
  end
end

PubSubSerial.run
