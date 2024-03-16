# frozen_string_literal: true

require_relative 'board'

class Game # rubocop:disable Metrics/ClassLength
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

  def user_input(next_moves = ['default value'])
    input = gets.chomp.downcase
    return if user_wants_to_quit?(input)

    transformed_input = transform_input(input)
    verified_input = verify_input(transformed_input, next_moves)
    return verified_input if verified_input

    puts 'Input error!'.red
    user_input(next_moves)
  end

  def verify_input(input, next_moves)
    if next_moves.include?('default value')
      input if not_off?(input) && same_color?(input) && occupied?(input)
    else
      input if next_move?(input, next_moves)
    end
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

  def turn
    puts "#{current_player.capitalize} player, it's your turn."
    select_piece
    board.move_piece(board.coord_to_move_to)
    puts 'Moved.'
    board.show
  end

  def switch_current_player
    @current_player = @current_player == 'white' ? 'black' : 'white'
  end

  def select_piece
    loop do
      select_piece_to_move
      break if select_cell_to_move_to
    end
  end

  def select_piece_to_move
    puts 'Select the piece you want to move. Write it like this: d4'
    coord_with_figure_to_move = user_input
    next_moves = board.possible_moves(coord_with_figure_to_move)
    board.update_curr_next_moves(next_moves)
  end

  def select_cell_to_move_to
    board.show(board.curr_next_moves)
    puts "Now select the cell you want to move to or type 'q' to reselect piece"
    new_coord = user_input(board.curr_next_moves)
    return if user_typed_q(new_coord)

    board.update_coord_to_move_to(new_coord)
    true
  end

  def user_typed_q(coord)
    coord.nil?
  end

  def user_wants_to_quit?(input)
    input.match?(/^q$/)
  end

  def transform_input(input)
    number = input[1].to_i
    transformed_number = (number - 8).abs
    letter = input[0].to_sym
    [transformed_number, letter]
  end

  def not_off?(input)
    input[0].between?(0, 7) && input[1].between?(:a, :h)
  end

  def same_color?(input)
    piece = board.piece_obj_from_coord(input)
    return true if board.empty_cell?(piece)

    piece.color == current_player
  end

  def occupied?(input)
    board.occupied_coord?(input)
  end

  def next_move?(input, next_moves)
    next_moves.include?(input)
  end
end
