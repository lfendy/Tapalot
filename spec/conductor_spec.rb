require 'spec_helper.rb'
require 'metronome'
require 'conductor'


describe Conductor do
  # init => take first section => instantiate metronome for section
  # run => run metronome => each tap, update count, update screen
  # when metronome done => instantiate next?
  
  # init should instantiate all required metronome  

  context "given a valid song" do

    before :each do
      song = 'song'
      s1 = 's1'
      s2 = 's2'
      stub(s1).rhythm {'v1'}
      stub(s2).rhythm {'v2'}
      mock(Metronome).new('v1') {'m1'}
      mock(Metronome).new('v2') {'m2'}
      stub(song).sections {[s1,s2]}
      stub(song).instruments {({})}
      @song = song
      @section1 = s1
      @section2 = s2
    end

    describe "#initialize" do
      it "should instantiate all associated metronomes for sections" do
        c = Conductor.new @song      
        c.metronomes.count.should == 2
        c.metronomes.include?('m1').should be_true
        c.metronomes.include?('m2').should be_true
        c.song.should == @song
      end

    end
    
    describe "#metronome" do
      it "should get the current sessions metronome" do
        c = Conductor.new @song      
        c.update_count
        c.metronome.should == 'm2'
      end
      it "should get the metronome at the index" do
        c = Conductor.new @song
        c.metronome(0).should == 'm1'
        c.metronome(1).should == 'm2'
      end
    end

    describe "#section" do
      it "should get the current session" do
        c = Conductor.new @song      
        c.update_count
        c.section.should == @section2
      end
      it "should get the current session" do
        c = Conductor.new @song      
        c.section(0).should == @section1
        c.section(1).should == @section2
      end
    end

    describe "#prev_sections" do
      it "should get array of previous sections" do
        c = Conductor.new @song
        c.update_count
        c.prev_sections.should == [@section1]
      end
      it "should return empty array if no previous sections" do
        c = Conductor.new @song
        c.prev_sections.should == []
      end
    end

    describe "#next_sections" do
      it "should return empty array if no next sections" do
        c = Conductor.new @song
        c.update_count
        c.update_count
        c.next_sections.should == []
      end
      it "should get array of next sections" do
        c = Conductor.new @song
        c.next_sections.should == [@section2]
      end
    end
    

  end

  describe "#reset" do
    it "should reset current section to 0" do
      c = Conductor.new
      c.reset
      c.current_section.should == 0
    end
  end

  describe "#update_count" do
    it "should increase current section index by 1" do
      c = Conductor.new
      c.reset
      c.update_count
      c.current_section.should == 1
    end
  end

  describe "#fill_rhythm" do
    it "should fill all sections with nil rhythm to previous section's rhythm" do
      c = Conductor.new
      require 'song'
      sections = [
                  SongSection.new({:rhythm => 'x'}),
                  SongSection.new({:rhythm => nil}),
                  SongSection.new({:rhythm => 'y'}),
                  SongSection.new({:rhythm => nil})
                 ]
      c.fill_rhythm sections
      sections.map(&:rhythm).should == ['x','x','y','y']
    end
  end

  describe "#init_instruments" do
    it "should create a new hash containing instrument keys with values set to false" do
      c = Conductor.new
      i = {:key1 => "value",:key2 => "value"}
      c.init_instruments(i).should == {:key1 => false, :key2 => false}
    end
  end

  describe "@update_instruments" do
    it "should set instrument to false according to transitions" do
      c = Conductor.new
      in_play = {'g' => true, 'd' => true, 'k' => true}
      transitions = [
                     {:command => '-', :instrument_key => 'g'}
                    ]
      c.update_instruments(in_play, transitions).should == {'g' => false, 'd' => true, 'k' => true}
    end

    it "should set instrument to true according to transitions" do
      c = Conductor.new
      in_play = {'g' => false, 'd' => false, 'k' => false}
      transitions = [
                     {:command => '+', :instrument_key => 'd'}
                    ]
      c.update_instruments(in_play, transitions).should == {'g' => false, 'd' => true, 'k' => false}
    end
  end


end

