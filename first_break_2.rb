# rubocop:disable Style/AsciiComments
require "pry"

# Załóż, że '#' działa jak klawisz backspace w ciągu znaków. Oznacza to że string "a#bc#d"
# jest równy "bd" .
# "abc#d##c" jest równy "ac"
# "abc##d######" jest równy ""
# "######" jest równy ""
# "" jest równy ""

# def backspace(string)
#   i = 0
#   while string[i]
#     if string[i] == '#'
#       string.slice!(i)
#       if i > 0
#         string.slice!(i - 1)
#         i -= 1
#       end
#     else
#       i += 1
#     end
#   end
#   string
# end

# puts backspace('abc#d##c')
# puts backspace('abc##d######')
# puts backspace('######')
# puts backspace('')
# puts backspace('aa#bb#cc#')




#  w zamyśle ten drugi pomysł miał być mega fajny i szybki;] wyszło tak se:)
# def backspace_smarter(string)
#   deleter = []
#   string.reverse.each_char.with_index do |char, i|
#     if char == '#'
#       2.times { deleter << 1 }
#     else
#       deleter << 0 if !deleter[i]
#     end
#   end
#   n = string.length - 1
#   deleter.each do |element|
#     string.slice!(n) if element == 1
#     n -= 1
#   end
#   string
# end
#
# puts backspace_smarter('abc#d##c')
# puts backspace_smarter('abc##d######')
# puts backspace_smarter('######')
# puts backspace_smarter('')
# puts backspace_smarter('aa#bb#cc#')

# ---------------------------------------------------------------------------
