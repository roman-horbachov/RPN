def infix_to_rpn(expression)
  tokens = expression.scan(/\d+|\+|\-|\*|\/|\^|\(|\)|×/)

  # пріоритети операторів
  operators = {
    '+' => { precedence: 2, associativity: 'Left' },
    '-' => { precedence: 2, associativity: 'Left' },
    '*' => { precedence: 3, associativity: 'Left' },
    '/' => { precedence: 3, associativity: 'Left' },
    '×' => { precedence: 3, associativity: 'Left' },
    '^' => { precedence: 4, associativity: 'Right' }
  }

  output_queue = []
  operator_stack = []

  tokens.each do |token|
    if token =~ /\d+/
      output_queue << token
    elsif operators.keys.include?(token)
      while operator_stack.any? &&
        operators.keys.include?(operator_stack.last) &&
        (
          (operators[token][:associativity] == 'Left' && operators[token][:precedence] <= operators[operator_stack.last][:precedence]) ||
            (operators[token][:associativity] == 'Right' && operators[token][:precedence] < operators[operator_stack.last][:precedence])
        )
        output_queue << operator_stack.pop
      end
      operator_stack << token
    elsif token == '('
      operator_stack << token
    elsif token == ')'
      while operator_stack.any? && operator_stack.last != '('
        output_queue << operator_stack.pop
      end
      operator_stack.pop
    end
  end

  # залишок операторів
  while operator_stack.any?
    output_queue << operator_stack.pop
  end
  output_queue.join(' ')
end

puts "Введіть математичний вираз:"
input_expression = gets.chomp
puts "RPN: #{infix_to_rpn(input_expression)}"