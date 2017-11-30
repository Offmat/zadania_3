# class to print the board on the screen, print informations and get user input
class BoardPresenter
  def initialize(board)
    @board = board
  end

  def print_separator
    11.times { print '+---' }
    puts '+'
  end

  def print_row(row)
    (0..10).each do |i|
      print '| '
      if row[i].is_a?(Field)
        if row[i].visible
          print row[i].ship ? 'X' : '.'
        else
          print ' '
        end
      else
        print row[i]
      end
      print ' ' unless row[0].to_s == '10' && i.zero?
    end
    puts '|'
    print_separator
  end

  def print_board
    2.times { puts }
    print_separator
    @board.each { |row| print_row(row) }
  end

  def take_shot
    puts
    print 'Choose target: '
    gets.chomp.upcase.split('', 2)
  end

  def greetings
    system 'clear'
    5.times { puts }
    puts "Hello! Let's play BATTLESHIPS!!".center(45, '-')
  end

  def react(var)
    system 'clear'
    5.times { puts }
    case var
    when false
      puts 'You missed the board! Please target inside A1 - J10 board.'.center(45, '-')
    when 0
      puts 'MISSED'.center(45, '-')
    when 1
      puts 'HIT'.center(45, '-')
    when 2
      puts 'Battleship is going down!'.center(45, '-')
    when 3
      puts "You've already shot this field".center(45, '-')
    end
    return true if var == 2
    false
  end

  def end_game
    system 'clear'
    5.times { puts }
    puts '-' * 45
    puts 'Congratulations!!  You won!!'.rjust(36)
    puts '-' * 45
    print_board
    exit(0)
  end
end
