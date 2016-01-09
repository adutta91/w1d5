require_relative 'board.rb'
require_relative 'human_player.rb'
require_relative 'tile.rb'

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
