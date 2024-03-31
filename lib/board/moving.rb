module Moving
  def move_piece(coord, destination_coord)
    piece = piece_obj_from_coord(coord)
    destination = piece_obj_from_coord(destination_coord)
  
    notify_of_taking(piece, destination, destination_coord)
    update_moved_status(piece)
    change_cells(piece, coord, destination_coord)
  end
  
  private

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

  def update_moved_status(piece)
    return unless piece.is_a?(Pawn) || piece.is_a?(King) || piece.is_a?(Rook)

    piece.update_status
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
    # rook_piece = piece_obj_from_coord(rook_coord)
    # change_cells(rook_piece, rook_coord, rook_destination_coord)

    move_piece(rook_coord, rook_destination_coord)
  end
end
