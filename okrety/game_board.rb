require 'pry'
require_relative 'field.rb'

# generats board and manage sea battle
class GameBoard
  attr_reader :avalible, :board, :fleet
  def initialize
    @fleet = 10
  end

  def generate_board
    @board = Array.new(11) { |k| Array.new(11) { |l| l.zero? ? k : Field.new } }
    @board[0] = [' '] + ('A'..'J').to_a
    generate_avalible
  end

  def generate_avalible
    @avalible = []
    10.times { |i| 10.times { |j| @avalible << [i + 1, j + 1] } }
  end

  def perimeter(x, y)
    (-1..1).each { |k| (-1..1).each { |l| @avalible.delete([x + k, y + l]) } }
  end

  def insert_ship(x, y, unit)
    @board[x][y].place_ship(unit)
    perimeter(x, y)
  end

  def check_target(target)
    return true if ('A'..'J').cover?(target[0]) && (1..10).cover?(target[1].to_i)
    false
  end

  def decoder(letter)
    ('A'..'J').to_a.index(letter) + 1
  end

  def shoot(target)
    return false if !check_target(target)
    @board[target[1].to_i][decoder(target[0])].shoot
  end

  def reveal(x, y)
    @board[x][y].make_visible if (1..10).cover?(x) && (1..10).cover?(y)
  end

  def ship_sunk(target)
    ship_location = @board[target[1].to_i][decoder(target[0])].unit.location
    ship_location.each do |array|
      (-1..1).each do |k|
        (-1..1).each { |l| reveal(array[0] + k, array[1] + l) }
      end
    end
    @fleet -= 1
  end
end
