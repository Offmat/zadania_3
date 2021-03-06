# rubocop:disable Style/AsciiComments
require 'pry'
require 'csv'
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

# Zadanie polega na napisaniu funkcji decode_morse , która dla otrzymanego kodu, zwórci
# jego odszyfrowaną wersję.
# Przykładowo:

# nie znalazłem metody wyszukania konkretnego Row w tablicy bez iterowania, więc chyba tak jest optymalnie:)
# def decode_morse(string)
#   decoder = {}
#   CSV.foreach('./morse_code.csv') { |row| decoder[row[1]] = row[0] }
#   answer = []
#   string.split.each { |sign| answer << decoder[sign]}
#   answer.join
# end
#
# p decode_morse('.... . .-.. .-.. --- .-- --- .-. .-.. -..') #=> "HELLOWORLD"

# ---------------------------------------------------------------------------

# W supermarkecie ludzie ustawiają się w jedną długą kolejkę i proszeni są kolejno do
# wolnej kasy.
# Twoim zadaniem jest napisać funkcję queue_time , która przyjmuje:
# • tablicę liczb całkowitych - czasy obsługi poszczególnych klientów
# • liczbę całkowitą - ilość dostępnych kas. Funkcja powinna zwracać czas potrzebny na
# obsłużenie wszystkich klientów supermarketu.
# Pamiętaj że:
# - istnieje tylko jedna kolejka
# - kolejność klientów w kolejce nie zmienia się
# - pierwsza osoba w kolejce podchodzi do pierwszej wolnej kasy
# Istnieje tylko jedna kasa, więc całkowity czas jest sumą czasów wszystkich klientów.
# W supermarkecie znajduje się dwie kasy, druga, trzecia i czwarta osoba wyjdzie ze
# sklepu przed pierwszą.

# class Desk
#   attr_reader :free
#   def initialize
#     @free = true
#     @customer = nil
#   end
#
#   def work
#     @customer -= 1
#     @free = true if @customer <= 0   # < na tak zwany wszelki wypadek:P
#   end
#
#   def new_client(amount)
#     @customer = amount
#     @free = false if @customer
#   end
# end
#
# # napisz mi proszę co sądzisz o dzieleniu tego. Rubocop mi powiedział, że jest za długa metoda, już miałem przerzucić while'a całego do nowej metody ale zastanowiło mnie, czy faktycznie dobrym pomysłem jest przekazywanie desks i clients dalej tylko po to żeby to rozbić na 2 metody? - kod zostałby bardzo podobny.
# def queue_time(clients, desks_number)
#   desks = Array.new(desks_number) { Desk.new }
#   working = true
#   time = 0
#   while working
#     # binding.pry
#     working = false
#     desks.each do |desk|
#       if desk.free
#         working = true if desk.new_client(clients.shift) == false
#       else
#         working = true
#       end
#       desk.work unless desk.free
#     end
#     time += 1 if working
#   end
#   time
# end

# def queue_time(clients, desks)
#   shop = Array.new(desks) { 0 }
#   clients.each { |client| shop[shop.index(shop.min)] += client }
#   shop.max
# end
#
# p queue_time([5, 3, 4], 1) #=> 12
# p queue_time([2, 3, 10], 2) #=> 12
# p queue_time([10, 2, 3, 3], 2) #=> 10

# ---------------------------------------------------------------------------

# Napisz funkcję consecutives_sum , która dla trzymanej tablicy liczb obliczy sumę kolejnych
# liczb o tej samej wartości.
# Funkcja powinna zwracać tablice tych sum.
# Przykładowo:

# def consecutives_sum(array)
#   sums = [array[0]]
#   j = 1
#   (1..array.length - 1).each do |i|
#     if array[i] == array[i - 1]
#       sums[j - 1] += array[i]
#     else
#       sums[j] = array[i]
#       j += 1
#     end
#   end
#   sums
# end
#
# p consecutives_sum([1, 4, 4, 4, 0, 4, 3, 3, 1]) #=> [1, 12, 0, 4, 6, 1]
# p consecutives_sum([1, 1, 7, 7, 3]) #=> [2, 14, 3]
# p consecutives_sum([-5, -5, 7, 7, 12, 0]) #=> [-10, 14, 12, 0]

# ---------------------------------------------------------------------------

# Zdefiniuj klasy Dog , Cat , Duck , Goose , każda z tych klas powinna dziedziczyć po klasie
# Animal , która posiada pustą metodę give_sound .
# Dla każdej z klas nadpisz metodę bazową give_sound , odpowiednio dla dźwięku
# poszczególnych zwierząt, przykłądowo dla psa wypisz 'woof! woof!' .
# Zdefiniuj klase Farm , która przyjmuje w metodzie 'initialize' tablicę obiektów Animals .
# Stwórz w klasie Farm metodę give_sounds , która wywołuje give_sound dla każdego obiektu z
# tablicy.

# # rubocop made me
# class Animal
#   def give_sound; end
# end
#
# # rubocop made me
# class Dog < Animal
#   def give_sound
#     puts 'bark! bark!'
#   end
# end
#
# # rubocop made me
# class Cat < Animal
#   def give_sound
#     puts 'meoooow!'
#   end
# end
#
# # rubocop made me
# class Duck < Animal
#   def give_sound
#     puts 'kwack, kwack'
#   end
# end
#
# # rubocop made me
# class Goose < Animal
#   def give_sound
#     puts 'idgad'
#   end
# end
#
# # rubocop made me
# class Farm < Animal
#   def initialize(animals)
#     @animals = animals
#   end
#
#   def give_sounds
#     @animals.each(&:give_sound)
#   end
# end
#
# farm = Farm.new([Dog.new, Cat.new, Duck.new, Goose.new])
# farm.give_sounds
