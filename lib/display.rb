module Display
  private

  def print_row(cell_index, row_index, row, possible_moves)
    row.each_value do |cell|
      print_cell(cell_index, row_index, cell, possible_moves)
      cell_index += 1
    end
  end

  def print_cell(cell_index, row_index, cell, possible_moves)
    cell_coord = find_coord(cell_index, row_index)
    if possible_moves&.include?(cell_coord)
      highlight_cell(cell_index, row_index, cell)
    else
      not_highlight_cell(cell_index, row_index, cell)
    end
  end

  def highlight_cell(cell_index, row_index, cell)
    if even_row?(row_index)
      highlight_cell_in_even_row(cell_index, cell)
    else
      highlight_cell_in_odd_row(cell_index, cell)
    end
  end

  def even_row?(row_index)
    row_index.even?
  end

  def highlight_cell_in_even_row(cell_index, cell)
    if even_cell?(cell_index)
      print cell.to_s.on_blue
    else
      print cell.to_s.on_red
    end
  end

  def highlight_cell_in_odd_row(cell_index, cell)
    if even_cell?(cell_index)
      print cell.to_s.on_red
    else
      print cell.to_s.on_blue
    end
  end

  def even_cell?(cell_index)
    cell_index.even?
  end

  def not_highlight_cell(row_index, cell_index, cell)
    if even_row?(row_index)
      print_cell_in_even_row(cell_index, cell)
    else
      print_cell_in_odd_row(cell_index, cell)
    end
  end

  def print_cell_in_even_row(cell_index, cell)
    if even_cell?(cell_index)
      print cell.to_s.on_yellow
    else
      print cell.to_s.on_gray
    end
  end

  def print_cell_in_odd_row(cell_index, cell)
    if even_cell?(cell_index)
      print cell.to_s.on_gray
    else
      print cell.to_s.on_yellow
    end
  end
end
