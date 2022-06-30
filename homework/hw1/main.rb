require 'pp'

# 1a
def palindrome? (string)
    treated_string = string.gsub(/\W/, "").downcase
    treated_string == treated_string.reverse
end

puts "Q. 1.a"
puts palindrome?("A man, a plan, a canal -- Panama") #=> true
puts palindrome?("Madam, I'm Adam!") # => true
puts palindrome?("Abracadabra") # => false (nil is also ok)
puts "---------------------------------------------------------------"

# 1b
def count_words(string)
    splited_string = string.downcase.split(' ').each { |w| w.gsub!(/\W/, "")}.reject {|str| str.nil? || str.empty? }
    result = {}
    splited_string.each do |str|
      if result[str].nil?
        result[str] = 1
      else
        result[str] += 1
      end
    end
    return result
end

puts "Q. 1.b"
puts count_words("A man, a plan, a canal -- Panama")
puts count_words "Doo bee doo bee doo" 
puts "---------------------------------------------------------------"

# 2a
class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end

def rps_game_winner(game)
    raise WrongNumberOfPlayersError unless game.length == 2

    valid_strategies = [:r, :p, :s]
    first_player_strategy = game.first[1].downcase.to_sym
    second_player_strategy = game.last[1].downcase.to_sym

    # Invalid strategy
    raise NoSuchStrategyError unless valid_strategies.include?(first_player_strategy) && valid_strategies.include?(second_player_strategy)

    # Both players have the same strategy
    return game.first unless first_player_strategy != second_player_strategy

    # Rock[:Scissor] = Win, Rock[:Paper] = Loss ...
    first_player_wins = { :r => { :s => true, :p => false}, :p => {:r => true, :s => false}, :s => {:r => false, :p => true}}

    return first_player_wins[first_player_strategy][second_player_strategy] ? game.first : game.last
end

puts "Q. 2.a"
puts rps_game_winner([ [ "Kristen", "P" ], [ "Pam", "S" ] ]).inspect
puts "---------------------------------------------------------------"

# 2b
def rps_tournament_round_winners(plays)
  winners = []
  game_winner = []

  plays.each_with_index do |play_1, index|
    if index % 2 == 0
      play_2 = plays[index+1]
      game_winner = rps_game_winner([play_1, play_2])
      if game_winner == play_1
        winners.push(play_1)
      else
        winners.push(play_2)
      end
    end
  end

  return winners
end

def rps_minor_tournament_winner(minor_tournament)
  winners = rps_tournament_round_winners(minor_tournament)

  while winners.size != 1 do
    winners = rps_tournament_round_winners(winners)
  end

  return winners[0]
end

def rps_tournament_winner(rps_tournament)  
  minor_tournaments_winners = []
  rps_tournament.each { |minor_tournament| minor_tournaments_winners.push(rps_minor_tournament_winner(minor_tournament.flatten(1))) }
  tournament_winner = rps_minor_tournament_winner(minor_tournaments_winners)
end

puts "Q. 2.b"
puts rps_tournament_winner([
  [
   [ ["Kristen", "P"], ["Dave", "S"] ],
   [ ["Richard", "R"], ["Michael", "S"] ],
  ],
  [
   [ ["Allen", "S"], ["Omer", "P"] ],
   [ ["David E.", "R"], ["Richard X.", "P"] ]
  ]
  ]).inspect
puts "---------------------------------------------------------------"

# 3
def combine_anagrams(words)
    result = []
    grouped_anagrams = words.group_by { |w| w.sum }
    grouped_anagrams.each { |_, value| result.push(value) }
    return result
end

puts "Q. 3"
puts combine_anagrams(['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams',
  'scream']).inspect
puts "---------------------------------------------------------------"

# 4a
class Dessert
  def initialize(name, calories)
   @name = name
   @calories = calories
  end

  def name ; @name ; end

  def name=(new_name)
    @name = new_name
  end
  
  def calories ; @calories ; end

  def calories=(new_calories)
    @calories = new_calories
  end

  def healthy?
   return @calories < 200
  end
  
  def delicious?
   return true
  end
end

# 4b

class JellyBean < Dessert
  def initialize(name, calories, flavor)
   @name = name
   @calories = calories
   @flavor = flavor
  end

  def flavor ; @flavor ; end

  def flavor=(new_flavor)
    @flavor = new_flavor
  end
  
  def delicious?
   return @flavor.downcase != 'black licorice'
  end
end

puts "Q. 4"
dessert = Dessert.new("Apple Pie", 180)
jelly_bean = JellyBean.new("JellyBean", 300, "Black Licorice")
puts "Dessert: #{dessert.name} has #{dessert.calories} calories and it's #{"not " if !dessert.delicious?}delicious!"
puts "Jelly Bean: #{jelly_bean.flavor} has #{jelly_bean.calories} calories and it's #{"not " if !jelly_bean.delicious?}delicious!"
puts "---------------------------------------------------------------"

# 5

class Class
  def attr_accessor_with_history(attr_name)
    attr_name = attr_name.to_s # make sure it's a string
    attr_reader attr_name # create the attribute's getter
    attr_reader attr_name+"_history" # create bar_history getter

    class_eval %Q{

      def #{attr_name}=(attr_value) 
        @#{attr_name} = attr_value
        if @#{attr_name}_history.nil?
          @#{attr_name}_history = [nil, attr_value]
        else
          @#{attr_name}_history.push(attr_value)
        end
      end

    }
  end
end

class Foo
  attr_accessor_with_history :bar
end

puts "Q. 5"
f = Foo.new # => #<Foo:0x127e678>
f.bar = 3 # => 3
f.bar = :wowzo # => :wowzo
f.bar = 'boo!' # => 'boo!'
puts f.bar_history.inspect # => [nil, 3, :wowzo, 'boo!']
puts "---------------------------------------------------------------"

# 6a
class Numeric
  @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019, 'dollar' => 1.0}

  def method_missing(method_id)
    singular_currency = method_id.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency].to_f
    else
      super
    end
  end

  def in(coin)
    singular_currency = coin.to_s.gsub( /s$/, '')
    currency = @@currencies[singular_currency]
    if currency
      puts (self /currency.to_f)
    else
      self.method_missing(coin)
    end
    
  end
end

puts "Q. 6.a"
5.dollars.in(:euros)
10.euros.in(:rupees)
puts "---------------------------------------------------------------"

# 6b
class String

  def palindrome?
    treated_string = self.gsub(/\W/, "").downcase
    treated_string == treated_string.reverse
  end
  
end

puts "Q. 6.b"
puts "foo".palindrome?
puts "Socorram-me! Subi no ônibus em Marrocos.".palindrome?
puts "---------------------------------------------------------------"

#6c
module Enumerable

  def palindrome?
    self == self.reverse
  end
  
end

puts "Q. 6.c"
puts [1,2,3,2,1].palindrome?
puts "---------------------------------------------------------------"

# 7
class CartesianProduct
  include Enumerable

  def initialize(sequence_1, sequence_2)
    @sequence_1 = sequence_1
    @sequence_2 = sequence_2
    @result = cartesian_product
  end

  def cartesian_product
    result = []
    @sequence_1.each do |item|
      result.push(@sequence_2.map { |x| ["#{item}".to_sym, x]})
    end
    return result.flatten(1)
  end

  def each
    yield @result
  end
end

puts "Q. 6.c"
c = CartesianProduct.new([:a,:b,:c], [4,5])
c.each { |elt| puts elt.inspect }
puts "---------------------------------------------------------------"