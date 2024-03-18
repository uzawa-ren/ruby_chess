# frozen_string_literal: true

require_relative 'board'
require_relative 'input'

class Game
  include Input
  attr_reader :current_player, :board, :winner

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

  private

  def introduction
    puts "Welcome to command line Chess! It's a tough game, so good luck!"
  end

  def turns
    until board.mate?
      turn
      break if board.stalemate?

      switch_current_player
    end
  end

  def conclusion
    if board.mate?
      puts "#{winner} team wins!"
    elsif board.stalemate?
      puts 'A draw!'
    end
  end

  def turn # rubocop:disable Metrics/AbcSize
    player = current_player == 'white' ? current_player.capitalize.on_gray :
                                         current_player.capitalize.black.on_white
    puts "#{player}, it's your turn."
    select_piece
    board.move_piece(board.coord_to_move, board.destination_coord)
    board.show
  end

  def switch_current_player
    @current_player = @current_player == 'white' ? 'black' : 'white'
  end
end
