require 'pry'
require 'curses'
require 'csv'

rows_main = 40
cols_main = 80

Curses.start_color
Curses.init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_BLACK) # text
Curses.init_pair(2, Curses::COLOR_RED, Curses::COLOR_RED) # frame
Curses.init_pair(3, Curses::COLOR_GREEN, Curses::COLOR_GREEN) # snake
Curses.init_pair(4, Curses::COLOR_GREEN, Curses::COLOR_BLACK) # additions

window = Curses::Window.new(ROWS, COLS, 0, 0)
window.keypad = true

menu = Menu.new
