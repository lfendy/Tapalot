module Console

  require 'colorize'

  String.class_eval do
    def spread
      " " + self + " "
    end
  end

  def print_beat(x,max_x)
    print "\rbeat: " + (1..max_x).to_a.map {|c| c == x ? c.to_s.spread.black.on_white : c.to_s }.join
  end

  def print_measure(x)
    print " measure: " + x.to_s.green
  end

  def clear_screen
    puts "\e[H\e[2J"
  end


end
