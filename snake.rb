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

ROWS = 40
COLS = 80

# wunż
class Snake
  attr_reader :location, :points
  def initialize
    @segments = 15
    @location = []
    @points = 0
  end

  def grow
    @segments += 1
  end

  def add_point
    @points += 1
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

def set_random(location, chr, color, window)
  loop do
    y = rand(ROWS - 2) + 1
    x = rand(COLS - 2) + 1
    next if location.include?([y, x])
    add_chr_at([y, x], chr, color, 3, window)
    break
  end
end

def move_snake(y, x, window)
  window.setpos(window.cury + y, window.curx + x)
end

# def show_points(window, snake)
#   str = 'press any key to go back'
#   print_on_screen(window, str, 6)
# end

def die(window, snake)
  window.color_set(4)
  window << 'X'
  window.refresh
  sleep(3)
  window.clear
  print_frame(window)
  str = "Congratulation!! You have earned #{snake.points} points"
  print_on_screen(window, str, 4)
  str = '[ ] Play again'
  print_on_screen(window, str, 6, 8)
  str = '[ ] Go to main menu'
  print_on_screen(window, str, 8, 8)
  str = '[ ] Exit game'
  print_on_screen(window, str, 10, 8)
  window.setpos(6, 9)
  Curses.curs_set(1)
  loop do
    case window.getch
    when Curses::Key::UP
      window.setpos(window.cury - 2, window.curx) if window.cury > 6
    when Curses::Key::DOWN
      window.setpos(window.cury + 2, window.curx) if window.cury < 10
    when ' '
      case window.cury
      when 6 then play_snake(window)
      when 8 then menu(window)
      when 10
        window.close
        exit(0)
      end
    end
  end


  window.getch
end

def play_snake(window)
  Curses.curs_set(0)   # niewidzialny kursor
  window.nodelay = true
  window.clear
  window.color_set(2)
  window.box('.', '.', '.')
  window.color_set(3)
  window.setpos(ROWS / 2, COLS / 2)
  set_random([ROWS / 2, COLS / 2], '@', 4, window)
  snake = Snake.new
  input = Curses::KEY_UP

  counter = 0
  until (input = window.getch || input) == 'q'
    # window.addstr("current x is #{window.curx}")
    # window.addstr("current begy is #{window.begy}")
    case input
    when Curses::Key::DOWN
      move_snake(1, 0, window)
    when Curses::Key::UP
      move_snake(-1, 0, window)
    when Curses::Key::RIGHT
      move_snake(0, 1, window)
    when Curses::Key::LEFT
      move_snake(0, -1, window)
    end

    if window.inch.chr == '@'
      snake.grow
      snake.add_point
      set_random(snake.location, '@', 4, window)
    end

    if counter > 20
      set_random(snake.location, '.', 2, window) if rand(2) == 1
      counter = 0
    end
    if window.inch.chr == '.'
      die(window, snake)
      input = 'q'
    end

    tail = snake.move(window.cury, window.curx)
    window.addch('.')
    window.setpos(window.cury, window.curx - 1)
    add_chr_at(tail, ' ', 4, 3, window) if tail
    counter += 1
    sleep(0.15)
  end
end

Curses.init_screen      # nie mam pojęcia po co to wszyscy wrzucają
Curses.noecho
# Curses.raw  # enter dalej nie działa, ale za to nie reaguje nawet na ctrl+c i trzeba zamykać terminal;]
Curses.start_color
Curses.nonl
Curses.init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_BLACK) # text
Curses.init_pair(2, Curses::COLOR_RED, Curses::COLOR_RED) # frame
Curses.init_pair(3, Curses::COLOR_GREEN, Curses::COLOR_GREEN) # snake
Curses.init_pair(4, Curses::COLOR_GREEN, Curses::COLOR_BLACK) # additions

# window.scrollok(true)
# window.idlok(true)     #sprawdzić później co robi idlok bo nie łapie do końca

def print_on_screen(window, str, y, x = (COLS - str.length)/2)
  window.setpos(y, x)
  window.addstr(str)
end

def print_frame(window)
  window.color_set(2)
  window.box('.', '.', '.')
  window.color_set(1)
end

def print_highscores(window)
  window.clear
  print_frame(window)
  str = 'Sie robi powoli'
  print_on_screen(window, str, 4)
  str = 'press any key to go back'
  print_on_screen(window, str, 6)
  menu(window) if window.getch
end

def introduction(window)
  window.clear
  print_frame(window)
  str = 'Sie robi powoli'
  print_on_screen(window, str, 4)
  str = 'press any key to go back'
  print_on_screen(window, str, 6)
  menu(window) if window.getch
end

def print_rules(window)
  window.clear
  print_frame(window)
  str = 'Sie robi powoli'
  print_on_screen(window, str, 4)
  str = 'press any key to go back'
  print_on_screen(window, str, 6)
  menu(window) if window.getch
end

def execute(window)
  case window.cury
  when 6 then play_snake(window)
  when 8 then print_highscores(window)
  when 10 then introduction(window)
  when 12 then print_rules(window)
  when 14
    window.close
    exit(0)
  end
end

def menu(window)
  print_frame(window)
  str = 'Welcome in my game. What do you want to do?'
  print_on_screen(window, str, 3)
  str = '(please use space bar to confirm, as I am not able to make Enter works)'
  print_on_screen(window, str, 4)
  str = "[ ] Let's play SNAKE!!"
  print_on_screen(window, str, 6, 8)
  str = '[ ] Show me high scores'
  print_on_screen(window, str, 8, 8)
  str = '[ ] Who made this?'
  print_on_screen(window, str, 10, 8)
  str = '[ ] What is this madness?'
  print_on_screen(window, str, 12, 8)
  str = '[ ] Get me out of here...'
  print_on_screen(window, str, 14, 8)

  window.setpos(6, 9)

  loop do
    case window.getch
    when Curses::Key::UP
      window.setpos(window.cury - 2, window.curx) if window.cury > 6
    when Curses::Key::DOWN
      window.setpos(window.cury + 2, window.curx) if window.cury < 14
    when ' '
      execute(window)
    end
  end
end

window = Curses::Window.new(ROWS, COLS, 0, 0)
window.keypad = true

menu(window)

window.getch
