require 'spec_helper.rb'

class Tapalot

  def initialize opts
    @opts = opts
  end

  def tap 
    beats = @opts[:beats]
    callback = @opts[:callback]
    beats.times {|x| callback.call((x+1).to_s)}
  end
end


describe Tapalot do

  describe "#tap" do
    it "should tap the correct beats for each measure" do
      to_tap = 'mockproc'
      beats = 3
      mock(to_tap).call('1')
      mock(to_tap).call('2')
      mock(to_tap).call('3')
      opts =  {
                :beats => beats,
                :measure => 4,
                :bpm => 100,
                :callback => to_tap
              }
      t = Tapalot.new opts
      t.tap 
    end



  end


end
