module CSVHelpers
  def new_row(column_numbers_and_values_hash)
    row = Array.new(Everbridge::CSV::COLUMNS.length)

    column_numbers_and_values_hash.each do |col_num, value|
      row[col_num] = value
    end

    row[row.length-1] = 'END'
    row
  end
end