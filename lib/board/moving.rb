module Moving
  def move_piece(coord, destination_coord)
    piece = find_piece(coord, destination_coord)
    destination = piece_obj_from_coord(destination_coord)

    notify_of_taking(piece, destination, destination_coord)
    update_piece_statuses(coord, destination_coord, piece)
    change_cells(piece, coord, destination_coord)
  end

  private

  def find_piece(coord, destination_coord)
    piece = piece_obj_from_coord(coord)
    promote_piece(piece, destination_coord)
  end

  def promote_piece(piece, destination_coord)
    return piece unless pawn_reached_last_row?(piece, destination_coord)

    player_choice = ask_to_which_piece_promote(destination_coord)
    chosen_piece(player_choice, game.current_player)
  end

  def pawn_reached_last_row?(piece, destination_coord)
    current_row = destination_coord[0]
    last_row = piece.color == 'white' ? 0 : 7
    piece.is_a?(Pawn) && current_row == last_row
  end

  def ask_to_which_piece_promote(destination_coord)
    coord = transform_array_to_string_coord(destination_coord)
    player_team = game.current_player.capitalize
    puts "#{player_team} team, to which piece promote the pawn at #{coord}?".magenta
    prompt = 'You can choose from bishop [b], knight [k], queen [q] or rook [r]: '.magenta
    game.user_input(prompt, /^[bkqr]$/)
  end

  def chosen_piece(player_choice, team_color)
    case player_choice
    when 'b'
      Bishop.new(team_color)
    when 'k'
      Knight.new(team_color)
    when 'q'
      Queen.new(team_color)
    when 'r'
      Rook.new(team_color, true)
    end
  end

  def notify_of_taking(taker, taked_piece, destination_coord)
    return if empty_cell?(taked_piece)

    taker = "#{taker.color} #{taker.class}".capitalize
    taked_piece = "#{taked_piece.color} #{taked_piece.class}".downcase
    destination_coord = transform_array_to_string_coord(destination_coord)
    puts "#{taker} takes #{taked_piece} at #{destination_coord}.".magenta
  end

  def transform_array_to_string_coord(array)
    array => number, letter # rubocop:disable Lint/Syntax
    transformed_number = (number - 8).abs
    "#{letter}#{transformed_number}"
  end

  def update_piece_statuses(coord, destination_coord, piece)
    update_moved_status(piece)
    update_just_made_double_step_status(coord, destination_coord, piece)
  end

  def update_moved_status(piece)
    return unless piece.is_a?(Pawn) || piece.is_a?(King) || piece.is_a?(Rook)

    piece.update_status
  end

  def update_just_made_double_step_status(coord, destination_coord, piece)
    team_color_to_dequeue = queue[0]&.color
    if piece.is_a?(Pawn) && double_move?(coord, destination_coord)
      piece.just_made_double_step = true
      queue << piece
    elsif team_color_to_dequeue == game.current_player
      pawn_to_change_status = queue.shift
      pawn_to_change_status.just_made_double_step = false
    end
  end

  def double_move?(coord, destination_coord)
    difference = destination_coord[0] - coord[0]
    difference.abs == 2
  end

  def change_cells(piece, coord, destination_coord)
    cells[destination_coord[0]][destination_coord[1]] = piece
    cells[coord[0]][coord[1]] = '   '

    return unless castling?(piece, coord, destination_coord)
    move_castling_rook(coord, destination_coord)
  end

  def castling?(piece, coord, destination_coord)
    piece.is_a?(King) && [[0, :e], [7, :e]].include?(coord) &&
      [[0, :g], [7, :g], [0, :c], [7, :c]].include?(destination_coord)
  end

  def move_castling_rook(coord, destination_coord)
    side = destination_coord[1] == :c ? 'left' : 'right'
    team_color = coord[0] == 7 ? 'white' : 'black'
    rook_coord = castling_rook_coord(side, team_color)
    row = destination_coord[0]
    rook_destination_coord = side == 'left' ? [row,  :d] : [row,  :f]

    move_piece(rook_coord, rook_destination_coord)
  end
end
