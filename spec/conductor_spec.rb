require 'spec_helper.rb'
require 'metronome'

class Conductor

  def initialize song
    song.sections.map {|x| Metronome.new x.rhythm }
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
      mock(Metronome).new('v1')
      mock(Metronome).new('v2')
  
      mock(song).sections {[s1,s2]}
      Conductor.new song      
    end

    

  end

end
