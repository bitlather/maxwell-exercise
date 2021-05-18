#==============================================================================
# Program is small, I want setup to be easy, so let's hack some unit tests.
#
# Usage:
#------------------------------------------------------------------------------
# $ ruby price_calculator_test.rb
#==============================================================================
require './price_calculator_service.rb'

def assert(actual, expected)
  if actual == expected
    puts "pass"
  else
    puts "FAIL"
    puts "  actual: #{actual}"
    puts "  expected: #{expected}"
  end
end

products = {
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
}

assert(
  PriceCalculatorService.break_into_array(''),
  []);

assert(
  PriceCalculatorService.break_into_array('milk,MILK,   milk    , mIlK'),
  ["milk", "milk", "milk", "milk"]);

assert(
  PriceCalculatorService.break_into_array('egg sandwich'),
  ["egg sandwich"]);

assert(
  PriceCalculatorService.quantify([]),
  {})

assert(
  PriceCalculatorService.quantify(["milk", "milk", "milk", "milk"]),
  {:milk=>4})

assert(
  PriceCalculatorService.quantify(["egg sandwich"]),
  {:"egg sandwich"=>1})

assert(
  PriceCalculatorService.quantify(["milk", "milk", "bread", "banana", "bread", "bread", "egg sandwich", "milk", "apple"]),
  {:milk=>3, :bread=>3, :banana=>1, :"egg sandwich"=>1, :apple=>1})


assert(
  PriceCalculatorService.checkout(products, {:a=>1, :milk=>4, :z=>1}),
  {
    :total_price=>10.0,
    :total_saved=>5.880000000000001,
    :items=>
    [
      {
        :name=>"Milk",
        :quantity=>4,
        :total_price=>15.88,
        :total_discounted_price=>10.0
      }
    ],
    :unrecognized=>[:a, :z]
  }
)