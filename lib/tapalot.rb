class Tapalot

  require 'actiontimer'
  attr_reader :current_tap, :current_measure

  def initialize opts
    @opts = opts
    @timer = ActionTimer::Timer.new(:auto_start => false)
    self.reset
  end

  def reset
    @current_tap = 1
    @current_measure = 1
  end

  def stop
    @timer.stop
  end

  def tap measures=1, &block
    bpm = @opts[:bpm]
    interval = 60.0 / bpm.to_f
    @timer.add({:period => interval, :once => false}) do
      yield current_tap, current_measure
      tick
      stop if current_measure > measures
    end
    @timer.start
  end

private

  def tick
    beats = @opts[:beats]
    @current_tap += 1
    if @current_tap > beats 
      @current_tap -= beats 
      @current_measure += 1
    end
  end

end
