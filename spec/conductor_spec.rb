require 'spec_helper.rb'
require 'metronome'

class Conductor

  attr_reader :metronomes, :current_session, :song
  def initialize song=nil
    @metronomes = song.sections.map {|x| Metronome.new x.rhythm } unless song.nil?
    @song = song
  end

  def reset
    @current_session = 0
  end

  def update_count
    @current_session += 1
  end

  def run

  end

end


describe Conductor do
  # init => take first section => instantiate metronome for section
  # run => run metronome => each tap, update count, update screen
  # when metronome done => instantiate next?
  
  # init should instantiate all required metronome  

  describe "#initialize" do

    it "should instantiate all associated metronomes for sections" do
      song = 'song'
      s1 = 's1'
      s2 = 's2'
      mock(s1).rhythm {'v1'}
      mock(s2).rhythm {'v2'}
      mock(Metronome).new('v1') {'m1'}
      mock(Metronome).new('v2') {'m2'}
  
      mock(song).sections {[s1,s2]}
      c = Conductor.new song      
      c.metronomes.count.should == 2
      c.metronomes.include?('m1').should be_true
      c.metronomes.include?('m2').should be_true
      c.song.should == song
    end

  end

  describe "#reset" do
    it "should reset current session to 0" do
      c = Conductor.new
      c.reset
      c.current_session.should == 0
    end
  end

  describe "#update_count" do
    it "should increase current session index by 1" do
      c = Conductor.new
      c.reset
      c.update_count
      c.current_session.should == 1
    end
  end
end

