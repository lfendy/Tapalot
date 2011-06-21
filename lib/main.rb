$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'metronome'
require 'console'
require 'song'
require 'conductor'

include Console

class Main

  def execute (args)
    $stdout.sync = true
    STDOUT.sync = true
    clear_screen
    f = File.open(args.shift)
    s = Song.parse f.read
    c = Conductor.new s

    mp3 = args.shift
    c.run
    system("afplay " + mp3) unless mp3.nil? || mp3.empty?
    sleep
  end

end

Main.new.execute(ARGV)
