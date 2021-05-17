#==============================================================================
# Usage:
#------------------------------------------------------------------------------
# $ ruby price_calculator.rb
# $ ruby price_calculator.rb "Milk, milk,BREAD"
#==============================================================================
require 'pp'

def run(products)
  items = break_into_array(ask_for_items)
  cart = quantify(items)

  puts "CART:"
  pp cart
  puts
  puts "PRODUCTS:"
  pp products
end

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

run({
  apple: {
    name: 'Apple',
    price: 0.89
  },
  banana: {
    name: 'Banana',
    price: 0.99
  },
  bread: {
    name: 'Bread',
    price: 2.17,
    sale: {
      quantity: 3,
      price: 6.00
    }
  },
  milk: {
    name: 'Milk',
    price: 3.97,
    sale: {
      quantity: 2,
      price: 5.00
    }
  }
})
