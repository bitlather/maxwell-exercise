#==============================================================================
# Usage:
#------------------------------------------------------------------------------
# $ ruby price_calculator.rb
# $ ruby price_calculator.rb "milk, milk,bread"
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

items = break_into_array(ask_for_items)

puts items
