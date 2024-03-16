module MovesFinding
  def occupied_coord?(coord)
    piece = piece_obj_from_coord(coord)
    !empty_cell?(piece)
  end

  private

  def piece_obj_from_coord(coord)
    cells[coord[0]][coord[1]]
  end

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

  def find_next_coord(coord, direction, piece_color, without_verification = false)
    next_row = coord[0] + direction[0]
    next_letter = find_next_letter(coord, direction)
    next_coord = [next_row, next_letter]
    return next_coord if without_verification

    next_coord unless invalid?(next_coord, coord, piece_color, direction)
  end

  def find_next_letter(coord, direction)
    num_to_letter_dict = %i[a b c d e f g h]
    current_letter_index = num_to_letter_dict.index(coord[1])
    next_letter_index = current_letter_index + direction[1]
    num_to_letter(next_letter_index)
  end

  def find_coord(cell_index, row_index)
    [row_index, num_to_letter(cell_index)]
  end

  def num_to_letter(num)
    return if num.negative?

    num_to_letter_dict = %i[a b c d e f g h]
    num_to_letter_dict[num]
  end

  def occupied_by_same_team?(cell, piece_color)
    return false if empty_cell?(cell)

    cell.color == piece_color
  end

  def crashed_into_opponent_piece?(curr_cell, prev_cell, team_color)
    return false if empty_cell?(prev_cell)

    prev_cell.color != team_color && empty_cell?(curr_cell)
  end

  def invalid_pawn_move?(coord, prev_coord, team_color, direction)
    case direction
    when [+1, -1], [+1, +1], [-1, -1], [-1, +1] # diagonal attack
      no_piece_to_take?(coord, team_color)
    when [+1, 0], [-1, 0] # forward 1 square
      occupied_coord?(coord)
    when [+2, 0], [-2, 0] # forward 2 squares
      moved?(prev_coord) || inbetween_coord_occupied?(coord, team_color)
    else
      false
    end
  end

  def no_piece_to_take?(coord, team_color)
    piece = piece_obj_from_coord(coord)
    empty_cell?(piece) || occupied_by_same_team?(piece, team_color)
  end

  def moved?(coord)
    piece = piece_obj_from_coord(coord)
    return if empty_cell?(piece)

    piece.moved
  end

  def inbetween_coord_occupied?(coord, team_color)
    direction = team_color == 'white' ? [1, 0] : [-1, 0]
    inbetween_coord = find_next_coord(coord, direction, team_color, true)
    occupied_coord?(inbetween_coord)
  end
end
