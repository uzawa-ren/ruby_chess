# frozen_string_literal: true

require_relative 'board'
require_relative 'input'

class Game
  include Input
  attr_reader :current_player, :board, :winner, :quit

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
    puts 'Welcome to command line Chess! Please write all coordinates like this: letter + number. Eg: d4'
    text = 'Would you like to play a new game [n] or load existing one [l]? '
    user_choice = user_input(text, /[nl]/)
    load_game if user_choice == 'l'
  end

  def turns
    until board.mate?
      turn
      break if quit || board.stalemate?

      switch_current_player
    end
  end

  def turn
    puts "#{hightlight_player_team}, it's your turn."
    select_piece
    return if quit

    board.move_piece(board.coord_to_move, board.destination_coord)
    board.show
  end

  # rubocop:disable Style/MultilineTernaryOperator

  def hightlight_player_team
    current_player == 'white' ? current_player.capitalize.on_gray : 
                                current_player.capitalize.black.on_white
  end
  # rubocop:enable Style/MultilineTernaryOperator

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
