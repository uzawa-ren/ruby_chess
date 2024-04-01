module PawnMovesFinding
  private

  def invalid_pawn_move?(coord, prev_coord, team_color, direction)
    case direction
    when [+1, -1], [+1, +1], [-1, -1], [-1, +1] # diagonal attack
      no_piece_to_take?(coord, prev_coord, direction)
    when [+1, 0], [-1, 0] # forward 1 square
      occupied_coord?(coord)
    when [+2, 0], [-2, 0] # forward 2 squares
      moved?(prev_coord) || inbetween_coord_occupied?(coord, team_color)
    else
      true
    end
  end

  def no_piece_to_take?(coord, prev_coord, direction)
    return false if can_take_en_passant?(coord, prev_coord, direction)

    empty_cell_by_coord?(coord)
  end

  def can_take_en_passant?(coord, prev_coord, direction)
    double_stepped_pawn_coord = find_double_stepped_pawn(prev_coord, direction)
    double_stepped_pawn = piece_obj_from_coord(double_stepped_pawn_coord)
    double_stepped_pawn.is_a?(Pawn) && double_stepped_pawn.just_made_double_step &&
      empty_cell_by_coord?(coord)
  end

  def find_double_stepped_pawn(prev_coord, direction)
    direction_to_double_stepped_pawn = find_direction_to_double_stepped_pawn(direction)
    double_stepped_pawn_letter = find_next_letter(prev_coord, direction_to_double_stepped_pawn)
    row = prev_coord[0]
    [row, double_stepped_pawn_letter]
  end

  def find_direction_to_double_stepped_pawn(direction)
    case direction
    when [-1, -1], [+1, -1]
      [0, -1]
    when [-1, +1], [+1, +1]
      [0, +1]
    end
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
