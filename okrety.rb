# rubocop:disable Style/AsciiComments
# Twoim zadaniem jest zaimplementowanie gry w Okręty dla 1 gracza.
# Gracz próbuje odgadnąć wszystkie pozycje statków wylosowanych przez program.
# Gra powinna przebiegać w następujący sposób:
# 1. Przygotowanie do gry:
# ◦ Stworzenie planszy 10x10.
# ◦ Losowe rozstawienie statków na planszy (1x czteromasztowiec, 2x
# trójmasztowiec, 3x dwumasztowiec, 4x jednomasztowiec). Statki nie mogą się
# stykać bokami ani rogami.
# 2. Przebieg rozgrywki:
# ◦ Prezentacja planszy.
# ◦ Gracz wprowadza pozycje (np. F3).
# ◦ Jeśli wprowadzona pozycja jest niepoprawna, proszony jest o podanie
# koordynatów jeszcze raz.◦ Program analizuje zadane pole i:
# ▪ Jeśli wskazane pole jest puste to wypisuje komunikat “Pudło” i oznacza
# pole znakiem “.”.
# ▪ Jeśli wskazane pole należy do statku to oznacza pole “X”. Dodatkowo jeśli
# jest to ostatnie pole statku to oznacza wszystkie pola wokół tego statku
# znakiem “.”. W przypadku częściowego trafienia wypisuje “Trafiony”, a dla
# zatopionego statku “Trafiony zatopiony”.
# 3. Gra kończy się gdy wszystkie statki zostały zniszczone.
require 'pry'

# Pole do gry w okręty
class Field
  attr_reader :ship, :visible, :unit   #dev tool
  def initialize
    @visible = ' '    # to chyba później zmienie na true/false, a co wy świetlać wrzucę gdzie indziej, ale jescze nie wiem
    @ship = false
  end

  def to_s
    @visible
  end

  # def to_s              # developer tool
  #   @ship ? 'S' : @visible
  # end

  def set_ship(unit)
    @ship = true
    @unit = unit
  end

  def shoot(reveal = false)
    if @ship
      @visible = 'X'
      @unit.hit unless reveal
      puts "HIT!!".rjust(25) unless reveal
    else
      @visible = '.'
      puts "You've missed...".rjust(32) unless reveal
    end
  end
end

# okręt
class Ship
  attr_reader :segments, :location    # dev tool
  def initialize(n, location, board)    #przez ten zwrot tablicy to jest praktycznie nie do oglądania w pry
    @segments = n
    @location = location
    @board = board
  end

  def hit
    @segments -= 1
    sink if @segments < 1
  end

  def sink
    @board.ship_sunk(@location)
  end

  def add_location(field)
    @location << field
  end
end


# Tablica do gry w okręty
class Board
  attr_reader :avalible, :fleet
  attr_reader :board      # dev tool
  def initialize
    generate_board
    generate_avalible
    fleet_generator
    @fleet = 10
  end

  def generate_board
    @board = Array.new(11) { |k| Array.new(11) { |l| l == 0 ? k : Field.new } }
    @board[0] = [' '] + ('A'..'J').to_a
  end

  def generate_avalible
    @avalible = []
    ('A'..'J').each { |i| 10.times { |j| @avalible << [i, j + 1] } }
  end

  def insert_ship(j, i, unit)
    field(j, i).set_ship(unit)
    perimeter(j, i)
  end

  def fleet_generator
    until ship_generator(4); end
    2.times { until ship_generator(3); end }
    3.times { until ship_generator(2); end }
    4.times { until ship_generator(2); end }
  end

  def ship_generator(n)
    seg = 1
    ship = [] << @avalible.sample
    # ship = [['C', 4]]
    direction = ['v', 'h'].sample   # vertical or horizontal
    # direction = 'h'
    movement = [-1, 1].sample       # forward or backward
    # movement = 1
    if direction == 'h'
      while seg < n
        ship[seg] = [(ship[seg - 1][0].ord + movement).chr, ship[seg - 1][1]]
        return false if !('A'..'J').include?(ship[seg][0]) || !@avalible.include?(ship[seg])
        seg += 1
      end
    end
    if direction == 'v'
      while seg < n
        ship[seg] = [ship[seg - 1][0], ship[seg - 1][1] + movement]
        return false if !(1..10).include?(ship[seg][1]) || !@avalible.include?(ship[seg])
        seg += 1
      end
    end
    unit = Ship.new(n, ship, self)
    ship.each { |segm| insert_ship(segm[0], segm[1], unit) }
    true
  end

  def print_separator
    11.times { print '+---' }
    puts '+'
  end

  def print_row(row)
    (0..10).each do |i|
      print '| ' + row[i].to_s
      print ' ' unless row[0].to_s == '10' && i.zero?
    end
    puts '|'
    print_separator
  end

  def print_board
    print_separator
    @board.each { |row| print_row(row) }
  end

  def field(j, i)
    decoder = Hash.new { |hash, k| hash[k] = ('A'..'J').to_a.index(k) + 1 }
    @board[i][decoder[j]]
  end

  def perimeter(j, i)
    (-1..1).each { |k| (-1..1).each { |l| @avalible.delete([(j.ord + k).chr, i + l]) } }
  end

  def shoot(j, i)
    field(j, i).shoot
  end

  def reveal(j, i)
    field(j, i).shoot(true) if ('A'..'J').include?(j) && (1..10).include?(i)
  end

  def ship_sunk(unit)
    unit.each do |array|
      # binding.pry
      (-1..1).each do |k|
        (-1..1).each { |l| reveal((array[0].ord + k).chr, array[1] + l) }
      end
    end
    @fleet -= 1
    end_game if @fleet < 1
  end

  def end_game
    puts "-"*45
    puts "Congratulations!!  You won!!".rjust(36)
    puts "-"*45
    print_board
    exit(0)   # czy tak może być? ułatwia mi to sprawę, bo nie muszę się martwić że np po gratulacjach wypisuje jeszczw HIT
  end
end

def check_target(target)
  # binding.pry
  return true if ('A'..'J').include?(target[0]) && (1..10).include?(target[1].to_i)
  puts "You missed the board! Please target inside A1 - J10 board."
  false
end

def lets_play
  puts "Hello! Lets play BATTLESHIPS!!"
  board = Board.new
  board.print_board
  while board.fleet > 0
    puts "Choose target: "
    target = gets.chomp.upcase.split("", 2)
    next if !check_target(target)
    board.shoot(target[0], target[1].to_i)
    board.print_board
  end
end

lets_play
