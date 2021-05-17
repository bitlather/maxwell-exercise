#==============================================================================
# Program is small, I want setup to be easy, so let's hack some unit tests.
#
# Usage:
#------------------------------------------------------------------------------
# $ ruby price_calculator_test.rb
#==============================================================================
require './price_calculator_logic.rb'

def assert(actual, expected)
  if actual == expected
    puts "pass"
  else
    puts "FAIL"
    puts "  actual: #{actual}"
    puts "  expected: #{expected}"
  end
end

assert(
  PriceCalculatorLogic.break_into_array(''),
  []);

assert(
  PriceCalculatorLogic.break_into_array('milk,MILK,   milk    , mIlK'),
  ["milk", "milk", "milk", "milk"]);

assert(
  PriceCalculatorLogic.break_into_array('egg sandwich'),
  ["egg sandwich"]);

assert(
  PriceCalculatorLogic.quantify([]),
  {})

assert(
  PriceCalculatorLogic.quantify(["milk", "milk", "milk", "milk"]),
  {:milk=>4})

assert(
  PriceCalculatorLogic.quantify(["egg sandwich"]),
  {:"egg sandwich"=>1})

assert(
  PriceCalculatorLogic.quantify(["milk", "milk", "bread", "banana", "bread", "bread", "egg sandwich", "milk", "apple"]),
  {:milk=>3, :bread=>3, :banana=>1, :"egg sandwich"=>1, :apple=>1})