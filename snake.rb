# rubocop:disable Style/AsciiComments
# Napisz interaktywną grę wąż w konsoli. Użyj gema curses do rysowania planszy w
# konsoli oraz odczytywania naciśniętych klawiszy. Wykorzystaj znaki ASCII # , @ , * (lub
# inne tego typu) do rysowania planszy, węża i owoców. Gracz powinien sterować wężem
# za pomocą strzałek kierunkowych.
# Uruchom wyobraźnię. Dodaj informację o zdobytych punktach, pozostałych “życiach”,
# czasie gry. Po włączeniu gry wyświetl graczowi menu z różnymi opcjami do wyboru
# (“Graj”, “Autorzy”, “Wyjście”, “Najlepsze wyniki” itp.).
# Najlepsze wyniki zapisz w pliku tekstowym i odczytaj je w programie.

require 'pry'
require 'curses'

ROWS = 30
COLS = 60

class Snake
  attr_reader :location
  def initialize
    @segments = 15
    @location = []
  end

  def grow
    @segments += 1
  end

  def move(y, x)
    @location.insert(0, [y, x])
    @location.delete_at(@segments)
  end
end

def add_chr_at(loc, chr, color_new, color_old, window)
  position = [window.cury, window.curx]
  window.color_set(color_new)
  window.setpos(loc[0], loc[1])
  window.addch(chr)
  window.color_set(color_old)
  window.setpos(position[0], position[1])
end

def set_fruit(location, window)
  loop do
  x = rand(COLS - 2) + 1
  y = rand(ROWS - 2) + 1
  next if location.include?([y, x])
  add_chr_at([y, x], '@', 3, 2, window)
  break
  end
end

Curses.init_screen      #nie mam pojęcia po co to wszyscy wrzucają
Curses.noecho
Curses.start_color
Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_RED)
Curses.init_pair(2, Curses::COLOR_GREEN, Curses::COLOR_GREEN)
Curses.init_pair(3, Curses::COLOR_GREEN, Curses::COLOR_BLACK)

window = Curses::Window.new(ROWS, COLS, 0, 0)
# window.scrollok(true)
# window.idlok(true)     #sprawdzić później co robi idlok bo nie łapie do końca
window.keypad = true
window.nodelay = true # temu leci i nie czeka

window.color_set(1)
window.box('.', '.', '.')
window.color_set(2)
window.setpos(ROWS / 2, COLS / 2)
set_fruit([], window)
snake = Snake.new
input = Curses::KEY_UP

def move(y, x, window)
  window.setpos(window.cury + y, window.curx + x)
end

until (input = window.getch || input) == 'q'
  # window.addstr("current x is #{window.curx}")
  # window.addstr("current begy is #{window.begy}")
  case input
  when Curses::KEY_DOWN
    move(1, 0, window)
  when Curses::KEY_UP
    move(-1, 0, window)
  when Curses::KEY_RIGHT
    move(0, 1, window)
  when Curses::KEY_LEFT
    move(0, -1, window)
  end

  if window.inch.chr == '@'
    snake.grow
    set_fruit(snake.location, window)
  end

  if window.inch.chr == '.'
    window.color_set(3)
    # puts "#{window.curx}, #{window.cury}"     # a to w ogóle wypluwał na poprzedzającym zderzenie polu, ale zakładam że to kwestia wpychania putsa do curses
    window.addch('x')      # tego nie chce za cholere zrobic
    sleep(3)      # to realizuje
    exit(0)
  end
  tail = snake.move(window.cury, window.curx)
  window.addch('.')
  window.setpos(window.cury, window.curx - 1)
  add_chr_at(tail, ' ', 3, 2, window) if tail
  sleep(0.15)
end
