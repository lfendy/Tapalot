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
    repetition = s.repetition
    idx = song.sections.index s
    sliced = song.sections.slice idx+1, 1000
    still_to_go = sliced.map{|x| x.heading}
    t = Tapalot.new({
                  :beats => beats,
                  :measure => rhythm.measure,
                  :tempo => rhythm.tempo
                })
    taps.push lambda { 
              t.tap(repetition) {
                |tap,measure| 
                print_beat(tap,beats) 
                print_measure(measure, repetition)
                print_heading(heading, still_to_go)
              } 
            }
    prev_tap.when_done taps.pop unless prev_tap.nil?
    prev_tap = t
  end
  clear_screen
  taps[0].call

end


Main.new.execute(ARGV)
