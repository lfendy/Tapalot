require 'polyglot'
require 'treetop'
require 'song_grammar'


class Song
  attr_reader :sections, :instruments, :transitions
  def initialize instruments, sections
    @sections = sections
    @instruments = instruments
  end
  def self.parse str
    sp = SongGrammarParser.new
    s = sp.parse str
    s.value
  end
end

class SongSection
  attr_reader :heading, :repetition, :transitions
  attr_accessor :rhythm
  def initialize opts
    @rhythm = opts[:rhythm]
    @heading = opts[:heading]
    @repetition = opts[:repetition]
    @transitions = opts[:transitions]
    
  end
end
