module Winning
  def mate?
    return false unless check?

    checker_team_color = find_checker_team_color
    receiver_team_color = game.other_player(checker_team_color)
    king_cannot_escape_from_taking?(checker_team_color, receiver_team_color) &&
      cannot_take_checker?(checker_team_color, receiver_team_color) ||
      did_not_save_king?(checker_team_color)
  end

  def stalemate?
    return false if check?

    stalemate_receiver = game.current_player
    stalemate_causer = game.other_player(stalemate_receiver)
    king_cannot_escape_from_taking?(stalemate_causer, stalemate_receiver)
  end

  def check?
    mutual_check? || gave_check?('white') || gave_check?('black')
  end

  private

  def mutual_check?
    gave_check?('white') && gave_check?('black')
  end

  def gave_check?(team_color)
    checker_player_pieces = all_pieces(team_color)
    checker_coord = find_checker_coord(checker_player_pieces, team_color)
    unless checker_coord
      game.checks[team_color] = false
      return false
    end

    notify_of_check(checker_coord, team_color) unless notified?(team_color)
    game.winners << team_color unless already_winner?(team_color)
    game.checks[team_color] = true
  end

  def all_pieces(team_color)
    result_array = []
    cells.each_with_index do |row, row_index|
      row.each do |letter, cell|
        next if empty_cell?(cell)

        result_array << [row_index, letter] if cell.color == team_color
      end
    end
    result_array
  end

  def find_checker_coord(checker_player_pieces, checker_team_color)
    checker_player_pieces.find { |piece| king_in_next_moves?(piece, checker_team_color) }
  end

  def king_in_next_moves?(piece, checker_team_color)
    receiver_team_color = game.other_player(checker_team_color)
    receiver_king = king_position(receiver_team_color)
    possible_moves(piece).any? do |next_coord|
      next_coord == receiver_king
    end
  end

  def notify_of_check(checker_coord, team_color)
    checker = string_of_checker(checker_coord)
    receiver = string_of_receiver(team_color)
    puts "#{checker} gives check to #{receiver}!".magenta
  end

  def string_of_checker(checker_coord)
    checker_piece = piece_obj_from_coord(checker_coord)
    "#{checker_piece.color} #{checker_piece.class}".capitalize
  end

  def string_of_receiver(team_color)
    other_team_color = game.other_player(team_color)
    receiver_piece = piece_obj_from_coord(king_position(other_team_color))
    "#{receiver_piece.color} #{receiver_piece.class}".downcase
  end

  def notified?(team_color)
    !!game.checks[team_color]
  end

  def already_winner?(team_color)
    game.winners.include?(team_color)
  end

  def find_all_player_moves(team_color)
    all_pieces(team_color).reduce([]) do |arr, coord|
      arr << possible_moves(coord)
    end
                                    .flatten(1).uniq
  end

  def find_checker_team_color
    game.checks.find { |_key, value| value == true }[0].to_s
  end

  def king_cannot_escape_from_taking?(checker_team_color, receiver_team_color)
    king_moves = possible_moves(king_position(receiver_team_color))
    return false if king_moves.empty?

    checker_player_moves = find_all_player_moves(checker_team_color)
    king_moves.all? { |move| checker_player_moves.include?(move) }
  end

  def cannot_take_checker?(checker_team_color, receiver_team_color)
    receiver_player_moves = find_all_player_moves(receiver_team_color)
    checker_player_pieces = all_pieces(checker_team_color)
    checker_coord = find_checker_coord(checker_player_pieces, checker_team_color)
    !receiver_player_moves.include?(checker_coord)
  end

  def did_not_save_king?(checker_team_color)
    game.current_player == checker_team_color
  end
end
