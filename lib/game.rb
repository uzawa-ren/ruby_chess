# frozen_string_literal: true

require_relative 'board'

class Game
  attr_reader :current_player, :curr_next_moves, :board, :winner

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
    puts "#{current_player.capitalize} player, it's your turn."
    loop do
      select_pice_to_move
      select_cell_to_move_to
    end
    board.show
  end

  def user_input(next_moves = [])
    input = gets.chomp.downcase

    transformed_input = transform_input(input)
    verified_input = verify_input(transformed_input, next_moves)
    return verified_input if verified_input

    puts 'Input error!'.red
    user_input
  end

  def verify_input(input, next_moves = [])
    return input if input[0].between?(0, 7) && input[1].between?(:a, :h) &&
                    (board.occupied_coord?(input) || next_moves.include?(input))
  end

  private

  def transform_input(input)
    number = input[1].to_i
    transformed_number = (number - 8).abs
    letter = input[0].to_sym
    [transformed_number, letter]
  end

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
