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

# zastanawiam się, czy jest sens robić klasę row, albo hashe, skoro arr of arrs się w tym miejscy chyba ze swoimi indeksami idealnie nada.

class Field
  def initialize
    @visible = ' '    # to chyba później zmienie na true/false, a co wy świetlać wrzucę gdzie indziej, ale jescze nie wiem
    @ship = false
  end

  def to_s
    @visible
  end

  def set_ship
    @ship = true
  end

  def shoot
    @visible = @ship ? 'X' : '.'
  end
end


def print_separator
  11.times { print '+---' }
  puts '+'
end

def print_row(array)
  (0..10).each do |i|
    print '| ' + array[i].to_s
    print ' ' unless array[0].to_s == '10' && i == 0
  end
  puts '|'
  print_separator
end

def print_board(aoa)
  print_separator
  aoa.each { |array| print_row(array) }
end

def generate_board
  board = Array.new(11) {|k| Array.new(11) {|l| l == 0 ? k : Field.new } }
  board[0] = [' '] + ('A'..'J').to_a
  board
end

def find(board, i, j)
  decoder = Hash.new { |hash, k| hash[k] = ('A'..'J').to_a[k-1]}
  board[decoder[j]][i]
end

def set_ship(board, i, j)
  board[j][i]
end

def check(board, i, j); end

def shot(board, i, j); end

board = generate_board
print_board(board)
