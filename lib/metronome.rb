class Metronome

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
    tempo = @opts[:tempo]
    interval = 60.0 / tempo.to_f
    @timer.add({:period => interval, :once => false}) do
      yield current_tap, current_measure
      tick
      done if current_measure > measures
    end
    @timer.start
  end

  def when_done callback
    @when_done_callback = callback
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

  def done
    stop
    @when_done_callback.call unless @when_done_callback.nil?
  end

end

