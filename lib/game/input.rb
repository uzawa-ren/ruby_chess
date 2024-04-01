module Input
  def coord_input(prompt, next_moves = ['default value'])
    print prompt
    input = gets.chomp.downcase
    @quit = true if user_wants_to_quit?(input, next_moves)
    return if needs_to_return?(input, next_moves)

    transformed_input = transform_string_coord_to_array(input)
    verified_input = verify_input(transformed_input, next_moves)
    return verified_input if verified_input

    puts 'Input error!'.red
    coord_input(prompt, next_moves)
  end

  def verify_input(input, next_moves)
    if selecting_piece_to_move?(next_moves)
      input if board.valid_piece?(input)
    else
      input if board.next_move?(input, next_moves)
    end
  end

  def user_input(prompt, regex)
    loop do
      print prompt
      input = gets.chomp
      return input if input.match(regex)

      puts 'Input error!'.red
    end
  end

  private

  def user_wants_to_quit?(input, next_moves)
    input.match?(/^quit$/) && selecting_piece_to_move?(next_moves)
  end

  def needs_to_return?(input, next_moves)
    quit || user_wants_to_reselect?(input, next_moves) || user_wants_to_save?(input, next_moves)
  end

  def user_wants_to_reselect?(input, next_moves)
    input.match?(/^r$/) && !selecting_piece_to_move?(next_moves)
  end

  def user_wants_to_save?(input, next_moves)
    input.match?(/^save$/) && selecting_piece_to_move?(next_moves)
  end

  def transform_string_coord_to_array(input)
    number = input[1].to_i
    transformed_number = (number - 8).abs
    letter = input[0].to_sym
    [transformed_number, letter]
  end

  def selecting_piece_to_move?(next_moves)
    next_moves.include?('default value')
  end

  def select_piece
    loop do
      select_piece_to_move
      break if quit

      break if select_destination_cell
    end
  end

  def select_piece_to_move
    prompt = "Select the piece you want to move. You can also type 'save' or 'quit': "
    input = coord_input(prompt)
    return if quit

    if user_typed_save?(input)
      save_game
      select_piece_to_move
      return
    end
    board.update_coord_to_move(input)
  end

  def user_typed_save?(coord)
    coord.nil?
  end

  def select_destination_cell
    next_moves = board.possible_moves(board.coord_to_move)
    board.show(next_moves)
    prompt = "Now select the cell you want to move to or type 'r' to reselect piece: "
    new_coord = coord_input(prompt, next_moves)
    return if user_typed_r?(new_coord)

    board.update_destination_coord(new_coord)
    true
  end

  def user_typed_r?(coord)
    coord.nil?
  end
end
