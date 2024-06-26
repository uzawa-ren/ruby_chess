module MovesFinding
  def possible_moves(coord)
    piece = piece_obj_from_coord(coord)
    return if empty_cell?(piece)

    directions = piece.class.move_directions(piece.color)
    find_all_moves(coord, directions, piece).compact
  end

  private

  def find_all_moves(coord, directions, piece)
    result_array = []
    directions.each do |direction|
      if piece.class.moves_linearly?
        find_line_of_next_moves(coord, direction, piece.color, result_array)
      else
        result_array << find_next_coord(coord, direction, piece.color)
      end
    end
    result_array
  end

  def find_line_of_next_moves(coord, direction, piece_color, result_array)
    next_coord = find_next_coord(coord, direction, piece_color)
    while next_coord
      result_array << next_coord
      next_coord = find_next_coord(next_coord, direction, piece_color)
    end
  end

  # rubocop:disable Style/OptionalBooleanParameter
  def find_next_coord(coord, direction, piece_color, without_verification = false)
    next_row = coord[0] + direction[0]
    next_letter = find_next_letter(coord, direction)
    next_coord = [next_row, next_letter]
    return next_coord if without_verification

    next_coord unless invalid_next_move?(next_coord, coord, piece_color, direction)
  end
  # rubocop:enable Style/OptionalBooleanParameter

  def find_next_letter(coord, direction)
    num_to_letter_dict = %i[a b c d e f g h]
    current_letter_index = num_to_letter_dict.index(coord[1])
    next_letter_index = current_letter_index + direction[1]
    num_to_letter(next_letter_index)
  end

  def num_to_letter(num)
    return if num.negative?

    num_to_letter_dict = %i[a b c d e f g h]
    num_to_letter_dict[num]
  end

  def invalid_next_move?(coord, prev_coord, team_color, direction)
    return true if off?(coord)

    cell = piece_obj_from_coord(coord)
    prev_cell = piece_obj_from_coord(prev_coord)

    return true if next_move_occupied_by_same_team?(cell, team_color) ||
                   already_crashed_into_opponent_piece?(cell, prev_cell, team_color)

    if prev_cell.instance_of?(Pawn)
      invalid_pawn_move?(coord, prev_coord, team_color, direction)
    elsif prev_cell.instance_of?(King)
      invalid_castling?(prev_coord, team_color, direction)
    end
  end

  def next_move_occupied_by_same_team?(cell, piece_color)
    return false if empty_cell?(cell)

    cell.color == piece_color
  end

  def already_crashed_into_opponent_piece?(curr_cell, prev_cell, team_color)
    return false if empty_cell?(prev_cell)

    prev_cell.color != team_color && empty_cell?(curr_cell)
  end

  def find_coord_from_indexes(cell_index, row_index)
    [row_index, num_to_letter(cell_index)]
  end
end
