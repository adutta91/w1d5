class Tile
  attr_accessor :value
  attr_reader :bomb, :facing_up, :flag
  def initialize
    @facing_up = false
    @bomb = false
    @flag = false
    @value = nil
  end

  def inspect
    # @facing_up.inspect
    @facing_up ? (@bomb ? "!" : @value) : (@flag ? "F" : "*")
  end

  def set_bomb
    @bomb = true
  end

  def flip_flag
    @flag = !@flag
  end

  def reveal
    @facing_up = true
  end

end


class Board
  MATH = [[+1, -1],
          [+1, +1],
          [-1, +1],
          [-1, -1],
          [0, 1],
          [1, 0],
          [-1, 0],
          [0, -1]]

  attr_reader :grid

  def initialize(size = 9, difficulty = 6)
    @grid = []

    temp_grid = Array.new(size ** 2) {Tile.new}
    difficulty.times do |index|
      temp_grid[index].set_bomb
    end

    temp_grid.shuffle!

    until temp_grid.empty?
      @grid << temp_grid.shift(size)
    end

  end

  # def populate(difficulty)
  # TODO: Move 95% of initialize to here
  # end

  def [](pos)
    col, row = pos
    grid[row][col]
  end


  def []=(pos, value)
    col, row = pos
    self.grid[row][col] = value
  end

  def inspect
    "\n" +
    @grid.map do |row|
      row.map { |tile| tile.inspect }.join(" ")
    end
    .join("\n")
  end

  def neighbors(pos)
    neighbors_array = MATH.map do |move|
      move.map.with_index {|shift, i| pos[i] + shift} # TODO refactor to get_possible_neighbors
    end

    neighbors_array.reject! do |neighbors| # TODO refactor to out_of_bounds
      neighbors.include?(-1) || neighbors.include?(@grid.length)
    end

    neighbors_array
  end

  def closed_neighbors(pos)
    neighbors(pos).reject do |neighbor_pos|
      self[neighbor_pos].facing_up
    end
  end

  def neighbor_bomb_count(pos)
    neighbors(pos).count { |neighbor_pos| self[neighbor_pos].bomb }
  end

  def length
    grid.length
  end

  def reveal(pos)
    queue = [pos]
    until queue.empty?
      current_pos = queue.pop
      bombs = neighbor_bomb_count(current_pos)

      self[current_pos].reveal
      self[current_pos].value = bombs

      queue.concat(closed_neighbors(current_pos)) if bombs == 0
    end
  end

  def won?
    # something
    board.
    boards row.select {is bomb = false = these have to be facing up}
  end
end

class Game

  attr_reader :board, :player

  def initialize(size, player)
    @board = Board.new(size)
    @player = player
    @stepped_on_bomb = false
  end

  def run_game
    until over?

      over = !over if any tile is both @bomb && @flipped_up
    end
  end

  def process_move
    while true
      move = player.get_move
      break if valid_move?(move)
    end

    option = move.pop.downcase.strip
    option == "r" ? reveal(move) : flag(move)
  end

  def valid_move?(move)
    pos = move.take(2)
    command = move.last.downcase.strip

    return false unless move.length == 3
    # p "passed test 1"
    return false unless ["f", "r"].include?(command)
    # p "passed test 2"
    return false if board[pos].facing_up
    # p "passed test 3"
    return false if pos.any? {|coord| coord < 0 || coord >= board.length}
    # p "passed test 4"
    return !board[pos].flag if command == "r"
    # p "passed test 5"
    true
  end

  def reveal(pos)
    board.reveal(pos) unless board[pos].flag
    @stepped_on_bomb = true if board[pos].bomb
  end

  def flag(pos)
    board[pos].flip_flag
  end

  def over?
    @stepped_on_bomb || board.won?
  end


end

class HumanPlayer

  def initialize(name = "Sweeperbot")
    @name = name
  end

  def get_move
    puts "input move & command (4, 2, F)"
    input = gets.chomp.split(",")
    parse_move(input)
    p input
    input
  end

  def parse_move(input)
    input[0..1] = input[0..1].map(&:to_i)
    input.last.strip!
  end

end
