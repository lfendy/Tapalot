class Conductor

  attr_reader :metronomes, :current_session, :song
  def initialize song=nil
    @metronomes = song.sections.map {|x| Metronome.new x.rhythm } unless song.nil?
    @song = song
    reset
  end

  def reset
    @current_session = 0
  end

  def update_count
    @current_session += 1
  end

  def run

  end

  def metronome idx=@current_session
    @metronomes[idx]
  end

  def section idx=@current_session
    @song.sections[idx]
  end


end


