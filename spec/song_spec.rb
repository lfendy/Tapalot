require 'spec_helper.rb'

require 'polyglot'
require 'treetop'
require 'song'
require 'song_grammar'




describe Song do

  #define unit tests later
  describe "#parse" do
    it "should parse" do

      str = "####
instruments:
g1: guitar1
g2: guitar2
d: drum
v: vocal
[3/4 180]
heading_1 4x  
heading_2 8x
[4/4 120]
heading_a 2x
heading_b 10x
####
"

      s = Song.parse str
      s.class.name.should == "Song"
      s.sections.count.should == 4
      sections = s.sections

      s1 = sections[0]
      s1.rhythm.should_not be_nil
      s1.rhythm[:beats].should == 3
      s1.rhythm[:measure].should == 4
      s1.rhythm[:tempo].should == 180
      s1.heading.include?("heading_1").should be_true
      s1.repetition.should == 4

      s2 = sections[1]
      s2.rhythm.should be_nil
      s2.heading.include?("heading_2").should be_true
      s2.repetition.should == 8

      s3 = sections[2]
      s3.rhythm.should_not be_nil
      s3.rhythm[:beats].should == 4
      s3.rhythm[:measure].should == 4
      s3.rhythm[:tempo].should == 120
      s3.heading.include?("heading_a").should be_true
      s3.repetition.should == 2

      s4 = sections[3]
      s4.rhythm.should be_nil
      s4.heading.include?("heading_b").should be_true
      s4.repetition.should == 10

      s.instruments.count.should == 4
      s.instruments["g1"].should == "guitar1"
      s.instruments["g2"].should == "guitar2"
      s.instruments["d"].should == "drum"
      s.instruments["v"].should == "vocal"
 
    end
  end

end

