require 'csv'
require 'pry'

scores = CSV.read('./high_scores.csv')
# binding.pry
p scores
scores.sort! { |x, y| x[1].to_i <=> y[1].to_i }

p scores
