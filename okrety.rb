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

# Pole do gry w statki
class Field
  def initialize
    @visible = ' '    # to chyba później zmienie na true/false, a co wy świetlać wrzucę gdzie indziej, ale jescze nie wiem
    @ship = false
  end

  def to_s
    @visible
  end

  # def to_s              #developer tool
  #   @ship ? 'S' : @visible
  # end

  def set_ship
    @ship = true
  end

  def shoot
    @visible = @ship ? 'X' : '.'
  end
end


# Tablica do gry w okręty
class Board
  attr_reader :avalible
  def initialize
    generate_board
    generate_avalible
  end

  def generate_board
    @board = Array.new(11) { |k| Array.new(11) { |l| l == 0 ? k : Field.new } }
    @board[0] = [' '] + ('A'..'J').to_a
  end

  def generate_avalible
    @avalible = []
    ('A'..'J').each { |i| 10.times { |j| @avalible << [i, j + 1] } }
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

  def set_ship(j, i)
    field(j, i).set_ship
    perimeter(j, i)
  end

  def shoot(j, i)
    field(j, i).shoot
  end

  def generate_ships(n)
    segment = 1
    ship = [] << @avalible.sample
    move = [rand(2), [-1, 1].sample]
    binding.pry
    ship[segment] = (ship[segment - 1][rand(2)].ord += [-1, 1].sample).chr
    puts 'a'
  end
end

board = Board.new
board.generate_ships(4)
# board.set_ship('C', 5)
# board.print_board
# p board.avalible
# board.shoot('A', 1)
# puts 'po pierwszym strzale'
# board.print_board
# board.shoot('C', 5)
# puts 'po drugim strzale'
# board.print_board
