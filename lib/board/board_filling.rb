module BoardFilling
  def fill_board
    empty_row = { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
    @cells = Array.new(8) { empty_row.clone }
    fill_row_with_king('black')
    fill_row_with_pawns('black')
    fill_row_with_pawns('white')
    fill_row_with_king('white')
  end

  def fill_row_with_king(team_color) # rubocop:disable Metrics/AbcSize
    row = team_color == 'white' ? 7 : 0
    cells[row][:a] = Rook.new(team_color)
    cells[row][:b] = Knight.new(team_color)
    cells[row][:c] = Bishop.new(team_color)
    cells[row][:d] = Queen.new(team_color)
    cells[row][:e] = King.new(team_color)
    cells[row][:f] = Bishop.new(team_color)
    cells[row][:g] = Knight.new(team_color)
    cells[row][:h] = Rook.new(team_color)
  end

  def fill_row_with_pawns(team_color)
    row = team_color == 'white' ? 6 : 1
    cells[row].each_key { |key| cells[row][key.to_sym] = Pawn.new(team_color) }
  end
end
