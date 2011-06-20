module Console

  require 'colorize'

  String.class_eval do
    def spread
      " " + self + " "
    end
    def align_right len
      x = self
      (len-self.length).times {x+=" "}
      x
    end
    def highlight_tap tap, max_tap
      section = self.length/max_tap
      start_idx = (tap-1)*section
      end_idx = (tap*section)-1
      range = (start_idx..end_idx)
      start = start_idx > 0 ? self[0..start_idx-1].green : ""
      mid = self[start_idx..end_idx].black.on_white  
      ends = end_idx + 1 < length ? self[end_idx+1..self.length].green : ""
      start + mid + ends
    end
  end

  def print_beat(x,max_x)
    position_cursor 0, 0
    print "beat: " + (1..max_x).to_a.map {|c| c == x ? c.to_s.spread.black.on_white : c.to_s }.join
  end

  def print_measure(x, max_x)
    print " measure: " + x.to_s.green + " of " + max_x.to_s.green
  end

  def print_heading hash
    heading = hash[:heading].green
    past_headings = hash[:past_headings]
    future_headings = hash[:future_headings]
    headings = past_headings.concat([heading]).concat(future_headings)
    print "\n\n" + headings.join("\n")
  end

  def print_instruments hash
    tap          = hash[:tap]
    beats        = hash[:beats]
    next_beats   = hash[:next_beats]
    in_play      = hash[:in_play]
    next_play    = hash[:next_play]
    heading      = hash[:heading]
    next_heading = hash[:next_heading]
    print "\n\n"
    print "\r    "
    print heading.align_right(4*beats+1).green
    print next_heading unless next_heading.nil?
    print "\n"

    in_play.each_key do |key|
      print key.align_right(4) + "|"
      plays = play(in_play[key], beats).highlight_tap(tap,beats)
      plays += "|" + play(next_play[key], next_beats) unless next_play.nil?
      print plays
      print "\n"
    end
    
  end

  def play in_play, beats
    s = in_play ? "#" : "_"
    r = "" 
    (beats*4).times { r += s }
    r
  end

  def clear_screen
    puts "\e[H\e[2J"
  end

  def position_cursor line, column
    print "\e[#{line};#{column}f"
  end


end


=begin
- Position the Cursor:
  \033[<L>;<C>H
     Or
  \033[<L>;<C>f
  puts the cursor at line L and column C.
- Move the cursor up N lines:
  \033[<N>A
- Move the cursor down N lines:
  \033[<N>B
- Move the cursor forward N columns:
  \033[<N>C
- Move the cursor backward N columns:
  \033[<N>D

- Clear the screen, move to (0,0):
  \033[2J
- Erase to end of line:
  \033[K

- Save cursor position:
  \033[s
- Restore cursor position:
  \033[u

echo -en "\033[7A\033[1;35m BASH \033[7B\033[6D"
=end

