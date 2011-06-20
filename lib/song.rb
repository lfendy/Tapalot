require 'polyglot'
require 'treetop'
require 'song_grammar'


class Song
  attr_reader :sections, :instruments
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
  attr_reader :heading, :repetition
  attr_accessor :rhythm
  def initialize opts
    @rhythm = opts[:rhythm]
    @heading = opts[:heading]
    @repetition = opts[:repetition]
    
  end
end
