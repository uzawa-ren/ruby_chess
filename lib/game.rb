# frozen_string_literal: true

require_relative 'board'

class Game
  attr_reader @current_player, @board, @winner

  def initialize
    @current_player = 'white'
    @board = Board.new
  end

  def play
    introduction
    board.show
    turns
    conclusion
  end

  def turn
    coord_with_figure_to_move = user_input # => юзер вводить "a2", однак метод повертає [2, 'a']
    next_moves = board.possible_moves(coord_with_figure_to_move)
    board.show(next_moves)
    coord_to_move_to = user_input # => a4
    board.move(coord_to_move_to)
    board.show
  end

  private

  def introduction
    puts "Welcome to command line Chess! It's a tough game, so good luck!"
  end

  def turns
    until board.mate?
      turn(current_player)
      break if board.stalemate?

      switch_current_player
    end
  end

  def switch_current_player
    @current_player = @current_player == 'white' ? 'black' : 'white'
  end

  def conclusion
    if board.mate?
      puts "#{winner} team wins!"
    elsif board.stalemate?
      puts 'A draw!'
    end
  end
end
