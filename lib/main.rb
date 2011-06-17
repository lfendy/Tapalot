$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'tapalot'
require 'console'
require 'song'

include Console

class Main

  def execute (args)
    $stdout.sync = true
    STDOUT.sync = true
    clear_screen
    f = File.open(args.shift)
    s = Song.parse f.read
    run s 
    sleep
  end

end


def run song
  rhythm = nil
  taps = []
  prev_tap = nil
  song.sections.each do |s|
    rhythm = s.rhythm.nil? ? rhythm : s.rhythm
    beats = rhythm.beats
    heading = s.heading
    t = Tapalot.new({
                  :beats => beats,
                  :measure => rhythm.measure,
                  :tempo => rhythm.tempo
                })
    taps.push lambda { 
              t.tap(s.repetition) {
                |tap,measure| 
                clear_screen
                print_beat(tap,beats) 
                print_measure(measure)
                print_heading(heading)
              } 
            }
    prev_tap.when_done taps.pop unless prev_tap.nil?
    prev_tap = t
  end
  taps[0].call

end


Main.new.execute(ARGV)
