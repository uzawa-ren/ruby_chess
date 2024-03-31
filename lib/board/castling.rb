module Castling
  def invalid_castling?(prev_coord, team_color, direction)
    if direction == [0, -2]
      return true if invalid_castling_for_side?(team_color, prev_coord, 'left')
    elsif direction == [0, +2]
      return true if invalid_castling_for_side?(team_color, prev_coord, 'right')
    end
    false
  end

  def invalid_castling_for_side?(team_color, prev_coord, side)
    return true if checked_team?(team_color)

    rook_or_king_have_moved?(side, team_color, prev_coord) ||
      path_is_not_empty?(side, team_color) || path_is_attacked?(side, team_color)
  end

  def checked_team?(team_color)
    other_team_color = game.other_player(team_color)
    game.checks[team_color] == false && game.checks[other_team_color] == true
  end

  def rook_or_king_have_moved?(side, team_color, king_coord)
    rook_coord = castling_rook_coord(side, team_color)
    rook_obj = piece_obj_from_coord(rook_coord)
    return true unless rook_obj.is_a?(Rook)

    moved?(rook_coord) || moved?(king_coord)
  end

  def castling_rook_coord(side, team_color)
    case [side, team_color]
    in 'left', 'white'
      [7, :a]
    in 'right', 'white'
      [7, :h]
    in 'left', 'black'
      [0, :a]
    in 'right', 'black'
      [0, :h]
    end
  end

  def path_is_not_empty?(side, team_color)
    path = castling_path_coords(side, team_color)
    path.any? { |coord| !empty_cell_by_coord?(coord) }
  end

  def castling_path_coords(side, team_color)
    case [side, team_color]
    in 'left', 'white'
      [[7, :b], [7, :c], [7, :d]]
    in 'right', 'white'
      [[7, :f], [7, :g]]
    in 'left', 'black'
      [[0, :b], [0, :c], [0, :d]]
    in 'right', 'black'
      [[0, :f], [0, :g]]
    end
  end

  def path_is_attacked?(side, team_color)
    path = castling_path_coords(side, team_color)
    opponent_moves = find_all_player_moves(game.other_player(team_color))
    return true if path.any? { |coord| opponent_moves.include?(coord) }

    path_is_attacked_by_pawns?(side, team_color)
  end

  def path_is_attacked_by_pawns?(side, team_color)
    attacking_pawns = pawns_attacking_path_coords(side, team_color)
    attacking_pawns.map! { |coord| piece_obj_from_coord(coord) }
    opponent_color = game.other_player(team_color)
    attacking_pawns.any? do |piece|
      next if empty_cell?(piece)

      piece.is_a?(Pawn) && piece.color == opponent_color
    end
  end

  def pawns_attacking_path_coords(side, team_color)
    case [side, team_color]
    in 'left', 'white'
      [[6, :a], [6, :b], [6, :c], [6, :e]]
    in 'right', 'white'
      [[6, :e], [6, :g], [6, :h]]
    in 'left', 'black'
      [[1, :a], [1, :b], [1, :c], [1, :e]]
    in 'right', 'black'
      [[1, :e], [1, :g], [1, :h]]
    end
  end
end
