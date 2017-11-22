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
  window.clear
  print_frame(window)
  str = 'Welcome in my game. What do you want to do?'
  print_on_screen(window, str, 3)
  str = '(use space bar to confirm, since I am not able to make Enter works)'
  print_on_screen(window, str, 4)
  str = "[ ] Let's play SNAKE!!"
  print_on_screen(window, str, 6, 17)
  str = '[ ] Show me high scores'
  print_on_screen(window, str, 8, 17)
  str = '[ ] Who made this?'
  print_on_screen(window, str, 10, 17)
  str = '[ ] What is this madness?'
  print_on_screen(window, str, 12, 17)
  str = '[ ] Get me out of here...'
  print_on_screen(window, str, 14, 17)

  window.setpos(6, 18)

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
