#==============================================================================
# Program is small, I want setup to be easy, so let's hack some unit tests.
#
# Usage:
#------------------------------------------------------------------------------
# $ ruby price_calculator_test.rb
#==============================================================================
require 'pp'
require './price_calculator_service.rb'

def assert(actual, expected)
  if actual == expected
    puts "pass"
  else
    puts "FAIL"
    puts "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
    puts "actual:"
    pp actual
    puts "---------------------------------------"
    puts "expected:"
    pp expected
    puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
  end
end

products = {
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
}

assert(
  PriceCalculatorService.break_items_into_array(''),
  []);

assert(
  PriceCalculatorService.break_items_into_array('milk,MILK,   milk    , mIlK'),
  ["milk", "milk", "milk", "milk"]);

assert(
  PriceCalculatorService.break_items_into_array('egg sandwich'),
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
    :total_price_cents=>1000,
    :total_saved_cents=>588,
    :items=>
    [
      {
        :name=>"Milk",
        :quantity=>4,
        :total_price_cents=>1588,
        :total_discounted_price_cents=>1000
      }
    ],
    :unrecognized=>[:a, :z]
  }
)

assert(
  PriceCalculatorService.checkout(products, {:milk=>3, :bread=>4, :banana=>1, :apple=>1}),
  {:total_price_cents=>1902,
   :total_saved_cents=>345,
   :items=>
    [{:name=>"Apple",
      :quantity=>1,
      :total_price_cents=>89,
      :total_discounted_price_cents=>89},
     {:name=>"Banana",
      :quantity=>1,
      :total_price_cents=>99,
      :total_discounted_price_cents=>99},
     {:name=>"Bread",
      :quantity=>4,
      :total_price_cents=>868,
      :total_discounted_price_cents=>817},
     {:name=>"Milk",
      :quantity=>3,
      :total_price_cents=>1191,
      :total_discounted_price_cents=>897}],
   :unrecognized=>[]}
)
