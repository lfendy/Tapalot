$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'tapalot'
require 'console'
include Console

class Main

  def execute (args)
    $stdout.sync = true
    clear_screen
    beats = 4
    opts =  {
              :beats => 4,
              :measure => 4,
              :bpm => 180
            }
    t = Tapalot.new opts
    t.tap(5){|tap,measure| print_beat(tap,beats); print_measure(measure)}
    sleep
  end

end


Main.new.execute(ARGV)
