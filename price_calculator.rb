#==============================================================================
# Usage:
#------------------------------------------------------------------------------
# $ ruby price_calculator.rb
# $ ruby price_calculator.rb "Milk, milk,BREAD,eggs"
#==============================================================================
require 'pp'

def run(products)
  items = break_into_array(ask_for_items)
  cart = quantify(items)
  receipt = checkout(products, cart)

  puts "CART:"
  pp cart
  puts
  puts "PRODUCTS:"
  pp products
  puts
  puts "RECEIPT:"
  pp receipt
  puts

  print_table(receipt)
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

    item = item.to_sym

    result[item] = 0 unless result.key? item
    result[item] += 1

  end

  result
end

def checkout(products, cart)
  receipt = {
    total_price: 0,
    total_saved: 0,
    items: [],
    unrecognized: []    
  }

  cart.keys.sort.each do |key|

    quantity = cart[key]

    if !products.key? key
      receipt[:unrecognized].push key
      next
    end

    product = products[key]

    item_total_price = quantity * product[:price]
    item_discounted_price = item_total_price

    if product.key? :sale
      num_sales_applied = (quantity / product[:sale][:quantity]).floor
      num_full_price = (num_sales_applied > 0) \
        ? quantity % (num_sales_applied * product[:sale][:quantity]) \
        : quantity

      item_discounted_price = num_full_price * product[:price] + num_sales_applied * product[:sale][:price]
    end

    receipt[:total_price] += item_discounted_price
    receipt[:total_saved] += (item_total_price - item_discounted_price)
    # Note: For two milks, we get :total_saved=>2.9400000000000004, so maybe we should store
    # the price of everything in cents to avoid floating point issues.

    receipt[:items].push({
      name: product[:name],
      quantity: quantity,
      total_price: item_total_price,
      total_discounted_price: item_discounted_price })

  end

  receipt
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
