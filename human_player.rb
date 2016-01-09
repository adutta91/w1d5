class HumanPlayer

  def initialize(name = "Sweeperbot")
    @name = name
  end

  def get_move
    puts "input move & command (4, 2, F)"
    input = gets.chomp.split(",")
    parse_move(input)
    input
  end

  def parse_move(input)
    input[0..1] = input[0..1].map(&:to_i)
    input.last.strip!
  end

end
