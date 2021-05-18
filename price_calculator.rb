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

  print_table(receipt)
end

def print_table(receipt)
  unrecognized = []
  printf "%-10s   %8s   %s\n", 'Item', 'Quantity', 'Price'
  puts "-" * 35
  receipt[:items].each do |item|
    printf "%-10s   %8s   $%.2f\n", item[:name], item[:quantity], item[:total_discounted_price]
  end

  puts
  printf "Total price: $%.2f\n", receipt[:total_price]
  printf "You saved $%.2f today.\n", receipt[:total_saved]
  puts
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
