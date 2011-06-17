module Console

  require 'colorize'

  String.class_eval do
    def spread
      " " + self + " "
    end
  end

  def print_beat(x,max_x)
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


end
