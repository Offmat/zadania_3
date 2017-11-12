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

class Snake
  def initialize
    @segments = 20
    @localization = []
  end

  def grow
    @segments += 1
  end

  def move(x, y)
    @localization.insert(0, [x, y])
    @localization.delete_at(@segments)
  end

end


ROWS = 40
COLS = 80

Curses.init_screen      #nie mam pojęcia po co to wszyscy wrzucają
Curses.noecho
Curses.start_color
Curses.init_pair(1, Curses::COLOR_RED, Curses::COLOR_BLACK)
Curses.init_pair(2, Curses::COLOR_BLUE, Curses::COLOR_GREEN)

window = Curses::Window.new(ROWS, COLS, 0, 0)
window.color_set(1)
# window.scrollok(true)
# window.idlok(true)     #sprawdzić później co robi idlok bo nie łapie do końca
window.keypad = true
window.nodelay = true # temu leci i nie czeka


window.addstr('Testing')
window.setpos(20, 40)
window.box('|', '-', '+')
window.color_set(2)

snake = Snake.new
input = Curses::KEY_UP
until (input = window.getch || input) == 'q'
  # window.addstr("current x is #{window.curx}")
  # window.addstr("current begy is #{window.begy}")
  window.setpos(window.cury + 1, window.curx) if  input == Curses::KEY_DOWN
  window.setpos(window.cury - 1, window.curx) if  input == Curses::KEY_UP
  window.setpos(window.cury, window.curx + 1) if  input == Curses::KEY_RIGHT
  window.setpos(window.cury, window.curx - 1) if  input == Curses::KEY_LEFT
  if ['.', '|', '-'].include?(window.inch.chr)
    window.color_set(1)
    # puts "#{window.curx}, #{window.cury}"     # a to w ogóle wypluwał na poprzedzającym zderzenie polu, ale zakładam że to kwestia wpychania putsa do curses
    window.delch
    window.addstr('x')      # tego nie chce za cholere zrobic
    sleep(3)      # to realizuje
    exit(0)
  end
  tail = snake.move(window.cury, window.curx)
  window.addch('.')
  head = [window.cury, window.curx - 1]
  if tail
    window.color_set(1)
    window.setpos(tail[0], tail[1])
    window.addch(' ')
    window.color_set(2)
  end
  window.setpos(head[0], head[1])
  sleep(0.15)
end
