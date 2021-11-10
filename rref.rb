
class MatrixRow
  def initialize(row)
    @numbers = row.split(' ').map(&:to_i)
  end

  def add!(operand)
    @numbers.map! do |num|
      num + operand
    end
  end

  def value(index)
    @numbers[index]
  end

  def normalize!(pivot_index)
    pivot = @numbers[pivot_index]
    @numbers.map! do |num|
      num.to_f / pivot
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

  def normalize_pivot!(column)
    @rows[column].normalize!(column)
  end
  def print
    @rows.each do |row|
      print_row(row)
    end
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

  def clear_out_row
    #tbd
  end
  def iterate
    if not is_pivot_normalized?
      @matrix.normalize_pivot!(@current_pivot_column)
    else
      clear_out_row
    end

    @current_working_row += 1
    @matrix.print
  end
end

userInput = gets.chomp.split('/')
userInput.each do |row|
  row.strip!
end

matrix = Matrix.new userInput
solver = RREFSolver.new matrix
solver.iterate