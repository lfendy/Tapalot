require 'spec_helper.rb'
require 'tapalot'

=begin
* how to keep going
* how to stop -- need to introduce timer
=end




describe Tapalot do

  describe "#reset" do
    it "should reset current tap and measure count to 1" do
      t = Tapalot.new({})
      t.reset
      t.current_tap.should == 1
      t.current_measure.should == 1
    end
  end

  describe "#tap" do

    before :each do
      @opts =  {
                :beats => 3,
                :measure => 4,
                :tempo => 180
               }
    end
  
    it "should tap the correct beats for each measure" do
      mockproc = 'mockproc'
      mock(mockproc).call(1)
      mock(mockproc).call(2)
      mock(mockproc).call(3)

      @opts[:tempo]      = 1800
      t = Tapalot.new @opts

      t.tap {|x| mockproc.call(x)}
      sleep(0.2)
    end

    it "should tap beat at appropriate times" do
      tempo = 1800
      bps = tempo.to_f / 60.0
      interval = 1.0 / bps
      now = Time.now
      check_for_timing = lambda { |x| 
                ((Time.now - now) - (interval*x)).abs.should < 0.001
               }
      @opts[:tempo]      = tempo
      t = Tapalot.new @opts
      t.tap &check_for_timing
      sleep(0.2)
    end

    it "should tap for correct number of measures" do
      mockproc = 'mockproc'
      mock(mockproc).call(1,1)
      mock(mockproc).call(2,1)
      mock(mockproc).call(3,1)
      mock(mockproc).call(1,2)
      mock(mockproc).call(2,2)
      mock(mockproc).call(3,2)

      @opts[:tempo]      = 1800
      t = Tapalot.new @opts

      t.tap(2) {|tap,measure| mockproc.call(tap,measure)}
      sleep(0.3)
    end
  end

  describe "#stop" do
    it "should stop tapping when told to" do
      mockproc = 'mockproc'
      mock(mockproc).call(1).times(2)
      mock(mockproc).call(2).times(2)
      mock(mockproc).call(3).times(2)

      @opts =  {
                :beats => 3,
                :measure => 4,
                :tempo => 1800
               }
      t = Tapalot.new @opts

      t.tap(10) {|x| mockproc.call(x)}
      sleep(0.21)
      t.stop
      sleep(0.2)
      
    end

    it "should invoke callback at stopping" do
      mockproc = 'mockproc'
      mock(mockproc).call().times(1)
      @opts =  {
                :beats => 3,
                :measure => 4,
                :tempo => 1800
               }
      t = Tapalot.new @opts
      t.when_done lambda { mockproc.call}
      t.tap(1) { }
      sleep(0.2)

    end
  end


end
