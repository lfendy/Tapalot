require 'console'

include Console

class Conductor

  attr_reader :metronomes, :current_section, :song
  def initialize song=nil
    return if song.nil?

    reset
    fill_rhythm song.sections
    @in_play = init_instruments song.instruments
    @metronomes = song.sections.map do |x| 
                                      Metronome.new x.rhythm 
                                    end  
    @song = song
  end

  def fill_rhythm sections
    sections.each_index {|i| 
                          sections[i].rhythm ||= sections[i-1].rhythm }
  end

  def init_instruments instruments
    result = {}
    instruments.each_key {|key| result[key] = false}
    result
  end

  def reset
    @current_section= 0
  end

  def update_count
    @current_section+= 1
  end

  def update_instruments instruments, transitions
    new_state = instruments.dup
    transitions.each do |t| 
                      new_state[t[:instrument_key]] = 
                                      (t[:command] == '+')
                     end unless transitions.nil?
    new_state
  end

  def run
    return if metronome.nil?
    @in_play = update_instruments @in_play, section.transitions
    next_play = next_section.nil? ?
                nil :
                update_instruments(@in_play, next_section.transitions)
    metronome.when_done lambda {
                          update_count
                          run
                        }
    rep = section.repetition
    beats = section.rhythm[:beats]
    heading = section.heading
    next_heading = next_section.heading unless next_section.nil?
    next_beats = next_section.rhythm[:beats] unless next_section.nil?
    metronome.tap(rep) {
                |tap,measure|
                position_cursor 0,0
                #print_beat(tap,beats)
                #print_measure(measure, rep)
                print_instruments({
                 :tap => tap,
                 :beats => beats,
                 :next_beats => next_beats,
                 :in_play => @in_play,
                 :next_play => next_play,
                 :heading => heading, 
                 :next_heading => next_heading
                })
                
                print_heading({
                                :past_headings => prev_sections.map(&:heading),
                                :heading => heading,  
                                :heading_progress => "   ..." + measure.to_s + "/" + rep.to_s,
                                :future_headings => next_sections.map(&:heading)
                              })
              }
  end

  def metronome idx=@current_section
    @metronomes[idx]
  end

  def section idx=@current_section
    @song.sections[idx]
  end

  def prev_sections
    return [] if @current_section == 0
    @song.sections[0..(@current_section-1)]
  end

  def next_sections
    to_return = @song.sections[(@current_section+1)..1000] #hackety hack hack
    return [] if to_return.nil?
    to_return
  end

  def next_section
    next_sections[0]
  end

end





