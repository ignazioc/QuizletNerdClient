class OutputFormatter
  def print_array_table(result_list, keys)
    table = Terminal::Table.new
    table.headings = keys.map(&:capitalize)

    result_list.each do |row|
      table.add_row(row.values)
    end
    puts table
  end

  def print_hash_table(result_hash)
    table = Terminal::Table.new do |t|
      t.headings = result_hash.keys.map(&:capitalize)
      t << result_hash.values
    end

    puts table
  end
end
