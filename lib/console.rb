module Console

  require 'colorize'

  String.class_eval do
    def spread
      " " + self + " "
    end
  end

  def print_beat(x,max_x)
    position_cursor 0, 0
    print "beat: " + (1..max_x).to_a.map {|c| c == x ? c.to_s.spread.black.on_white : c.to_s }.join
  end

  def print_measure(x, max_x)
    print " measure: " + x.to_s.green + " of " + max_x.to_s.green
  end

  def print_heading heading, still_to_go
    print "\n\n" + heading.green + "\n" + still_to_go.join("\n")
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

