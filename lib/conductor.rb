require 'console'

include Console

class Conductor

  attr_reader :metronomes, :current_section, :song
  def initialize song=nil
    reset
    return if song.nil?
    @song = song
    @song.sections.each_index {|i| 
                                @song.sections[i].rhythm ||= @song.sections[i-1].rhythm }
                            
    @metronomes = @song.sections.map {|x| 
                                     Metronome.new x.rhythm 
                                     } 
  end

  def reset
    @current_section= 0
  end

  def update_count
    @current_section+= 1
  end

  def run
    return if metronome.nil?
    metronome.when_done lambda {
                          update_count
                          run
                        }
    metronome.tap(section.repetition) {
                |tap,measure|
                print_beat(tap,section.rhythm[:beats])
                print_measure(measure, section.repetition)
                print_heading({
                                :past_headings => prev_sections.map(&:heading),
                                :heading => section.heading,
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

end




