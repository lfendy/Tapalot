$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'tapalot'

class Main

  def execute (args)
    opts =  {
              :beats => 4,
              :bpm => 180
            }
    t = Tapalot.new opts
    t.tap(4){|x| print "\r#{x.to_s}"}
    sleep
  end

end


Main.new.execute(ARGV)
