require 'spec_helper.rb'
require 'metronome'

class Conductor

  attr_reader :metronomes
  def initialize song
    @metronomes = song.sections.map {|x| Metronome.new x.rhythm }
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
    end

    

  end

end
