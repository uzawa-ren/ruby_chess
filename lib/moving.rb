module Moving
  def move_piece(coord, destination_coord)
    piece = piece_obj_from_coord(coord)
    destination = piece_obj_from_coord(destination_coord)
  
    notify_of_taking(piece, destination, destination_coord)
    piece.update_status if piece.is_a?(Pawn)
    change_cells(piece, coord, destination_coord)
  end
  
  private

  def change_cells(piece, coord, destination_coord)
    cells[destination_coord[0]][destination_coord[1]] = piece
    cells[coord[0]][coord[1]] = '   '
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
end
