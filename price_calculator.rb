#==============================================================================
# Usage:
#------------------------------------------------------------------------------
# $ ruby price_calculator.rb
# $ ruby price_calculator.rb items="Milk, milk,BREAD,eggs"
#==============================================================================
require './price_calculator_service.rb'

def run(products)
  input = PriceCalculatorService.ask_for_items
  items = PriceCalculatorService.break_into_array(input)
  cart = PriceCalculatorService.quantify(items)
  receipt = PriceCalculatorService.checkout(products, cart)
require 'pp'
pp cart
pp receipt
  print_table(receipt)
end

def print_table(receipt)
  unrecognized = []
  printf "%-10s   %8s   %s\n", 'Item', 'Quantity', 'Price'
  puts "-" * 35
  receipt[:items].each do |item|
    printf "%-10s   %8s   $%.2f\n", item[:name], item[:quantity], (item[:total_discounted_price_cents] / 100.0)
  end

  puts
  printf "Total price: $%.2f\n", (receipt[:total_price_cents] / 100.0)
  printf "You saved $%.2f today.\n", (receipt[:total_saved_cents] / 100.0)
  puts
end

run({
  apple: {
    name: 'Apple',
    price_cents: 89
  },
  banana: {
    name: 'Banana',
    price_cents: 99
  },
  bread: {
    name: 'Bread',
    price_cents: 217,
    sale: {
      quantity: 3,
      price_cents: 600
    }
  },
  milk: {
    name: 'Milk',
    price_cents: 397,
    sale: {
      quantity: 2,
      price_cents: 500
    }
  }
})
