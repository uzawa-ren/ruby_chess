# frozen_string_literal: true

require_relative '../board/board'
require_relative 'input'
require_relative 'saving'

class Game
  include Input
  include Saving
  attr_reader :current_player, :board
  attr_accessor :checks, :winners

  def initialize
    @current_player = 'white'
    @board = Board.new(self)
    @winners = []
    @checks = {}
    @notified_checks = {}
  end

  def play
    introduction
    board.show
    turns
    conclusion
  end

  def other_player(team_color)
    team_color == 'white' ? 'black' : 'white'
  end

  private

  attr_reader :quit

  def introduction
    puts welcome_message
    text = 'Would you like to play a new game [n] or load an existing one [l]? '
    user_choice = user_input(text, /[nl]/)
    load_game if user_choice == 'l'
  end

  def welcome_message
    <<~HEREDOC
      \e[35mWelcome to Chess!\e[0m

      Each turn will be played in two steps.

      \e[35mStep One:\e[0m
      Enter the coordinate of the piece you want to move.

      \e[35mStep Two:\e[0m
      Enter the legal coordinate of the cell you want to move to.

      \e[35mExample of how to input a coordinate:\e[0m d4

    HEREDOC
  end

  def turns
    until board.mate? || board.stalemate?
      turn
      break if quit

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
      puts "#{winners.uniq.join(' team and ').capitalize} team wins!"
    elsif board.stalemate?
      puts 'A draw!'
    end
  end
end
