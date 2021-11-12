
class MatrixRow
  @@precision = 2

  def initialize(row)
    @numbers = row.split(' ').map(&:to_i)
  end

  def add_with_row(row, multiplier)
    return if row.length != length

    @numbers = @numbers.zip(row.values).map do |num, num2|
      (num + (multiplier * num2.to_f)).round(@@precision)
    end
  end

  def length
    @numbers.length
  end

  def values
    @numbers
  end

  def value(index)
    @numbers[index]
  end

  def normalize!(pivot_index)
    pivot = @numbers[pivot_index]
    @numbers.map! do |num|
      (num.to_f / pivot).round(@@precision)
    end
  end

  def to_s(delimiter=' ')
    @numbers.join(delimiter)
  end
end

def print_row(row)
  puts "- #{row.to_s(' | ')} -"
end

class Matrix
  def initialize(rows)
    @rows = rows.map do |row|
      MatrixRow.new(row)
    end
  end

  def is_normalized?(column)
    @rows[column].value(column) == 1
  end

  def add_rows(target_row, reference_row, multiplier)
    @rows[target_row].add_with_row(@rows[reference_row], multiplier)
  end

  def value_at(row, column)
    @rows[row].value(column)
  end

  def normalize_pivot!(column)
    @rows[column].normalize!(column)
  end
  def dimension
    @rows.length
  end
  def print
    @rows.each do |row|
      print_row(row)
    end

    puts
  end
end

class RREFSolver
  def initialize(matrix)
    @matrix = matrix
    @current_pivot_column = 0
    @current_working_row = 0
  end

  def is_pivot_normalized?
    @matrix.is_normalized?(@current_pivot_column)
  end

  def at_pivot?
    @current_working_row == @current_pivot_column
  end

  def clear_out_row
    multiplier = -(@matrix.value_at(@current_working_row, @current_pivot_column))
    @matrix.add_rows(@current_working_row, @current_pivot_column, multiplier)
  end

  def is_matrix_in_rref
    @current_working_row += 1
    if @current_working_row >= @matrix.dimension
      if @current_pivot_column == @matrix.dimension - 1
        return true
      end

      @current_working_row = 0
      @current_pivot_column += 1
    end

    return false
  end

  def iterate
    if not is_pivot_normalized?
      @matrix.normalize_pivot!(@current_pivot_column)
      @matrix.print
      iterate
      return
    elsif not at_pivot?
      clear_out_row
    end

    @matrix.print
    iterate unless is_matrix_in_rref
  end
end

userInput = gets.chomp.split('/')
userInput.each do |row|
  row.strip!
end

matrix = Matrix.new userInput
solver = RREFSolver.new matrix
solver.iterate