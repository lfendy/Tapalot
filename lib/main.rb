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
    c.run
    system("afplay iris.mp3")
    #run s 
    sleep
  end

end


def run song
  rhythm = nil
  taps = []
  prev_tap = nil
  song.sections.each do |s|
    heading = s.heading
    repetition = s.repetition
    t = Metronome.new s.rhythm
    taps.push lambda { 
              t.tap(repetition) {
                |tap,measure| 
                print_beat(tap,6) 
                print_measure(measure, repetition)
                print_heading(heading, [])
              } 
            }
    prev_tap.when_done taps.pop unless prev_tap.nil?
    prev_tap = t
  end
  clear_screen
  taps[0].call

end


Main.new.execute(ARGV)
