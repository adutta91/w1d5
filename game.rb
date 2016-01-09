require_relative 'board.rb'
require_relative 'human_player.rb'
require_relative 'tile.rb'

class Game

  attr_reader :board, :player

  def initialize(size, player)
    @board = Board.new(size)
    @player = player
    @stepped_on_bomb = false
  end

  def run_game
    system("clear")

    until over?
      p board
      process_move
      system("clear")
    end

    board.won? ? puts("You won! :D") : puts("You lost :(")
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
    return false unless ["f", "r"].include?(command)
    return false if board[pos].facing_up
    return false if pos.any? {|coord| coord < 0 || coord >= board.length}
    return !board[pos].flag if command == "r"

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
