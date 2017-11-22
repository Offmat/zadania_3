require "curses"

ROWS = 30
COLS = 80

begin
  Curses.init_screen
  Curses.start_color
  Curses.init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_RED) # define color pair (foreground + background), used by color_set
  Curses.init_pair(2, Curses::COLOR_WHITE, Curses::COLOR_YELLOW)
  Curses.curs_set(0)
  Curses.noecho

  window = Curses::Window.new(ROWS, COLS, 0, 0)
  window.keypad = true
  window.nodelay = true

  loop do
    msg = nil

    case window.getch
    when "q"
      exit
    when Curses::Key::LEFT
      msg = "left arrow pressed"
    when Curses::Key::RIGHT
      msg = "right arrow pressed"
    when Curses::Key::UP
      msg = "up arrow pressed"
    when Curses::Key::DOWN
      msg = "down arrow pressed"
    end

    # clear keyboard buffer if they are any buffered keys
    window.getstr

    window.clear
    window.color_set(2) # choose color from index 2 (see init_pair)
    window.box(" ", " ", " ")
    window.setpos(10, 10)
    window.color_set(1) # choose color from index 1
    window.addstr(" ")  # display space but because we changed background color it will be rendered as colorful rectangle
    if msg
      window.setpos(1, 1)
      window.addstr(msg)
    end
    window.refresh
    sleep 0.2
  end
ensure
  Curses.close_screen
end
