#==============================================================================
# Usage:
#------------------------------------------------------------------------------
# $ ruby price_calculator.rb
# $ ruby price_calculator.rb "Milk, milk,BREAD"
#==============================================================================

def ask_for_items
  puts
  puts "Please enter all the items purchased separated by a comma"
  if ARGV.length == 0
    input = STDIN.gets.chomp
  else
    input = ARGV[0]
    puts input
  end
  puts
  input
end

def break_into_array(input)
  items = input.split(",")
  items.each do |item|
    item.strip!
    item.downcase!
  end
  items
end

def quantify(items)
  result = {}
  items.each do |item|
    result[item] = 0 unless result.key? item
    result[item] += 1
  end
  result
end

items = break_into_array(ask_for_items)
cart = quantify(items)

require 'pp'
pp cart
