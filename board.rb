require_relative 'board.rb'
require_relative 'human_player.rb'
require_relative 'tile.rb'

class Board
  MATH = [[1, -1],
          [1, 1],
          [-1, 1],
          [-1, -1],
          [0, 1],
          [1, 0],
          [-1, 0],
          [0, -1]]

  attr_reader :grid

  def initialize(size = 10, difficulty = 10)
    @grid = []
    populate(size, difficulty)
  end

  def populate(size, difficulty)
    temp_grid = Array.new(size ** 2) {Tile.new}

    difficulty.times { |index| temp_grid[index].set_bomb }

    temp_grid.shuffle!

    @grid << temp_grid.shift(size) until temp_grid.empty?
  end

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
    prune_out_of_bounds(get_possible_neighbors(pos))
  end

  def get_possible_neighbors(pos)
    MATH.map do |move|
      move.map.with_index {|shift, i| pos[i] + shift}
    end
  end

  def prune_out_of_bounds(neighbors_array)
    neighbors_array.reject do |neighbors|
      neighbors.include?(-1) || neighbors.include?(@grid.length)
    end
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
    # safe_tiles = grid.flatten.reject { |tile| tile.bomb }
    grid.flatten.all? { |tile| tile.bomb != tile.facing_up }
  end

end
